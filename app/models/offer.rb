class Offer < ActiveRecord::Base
  tokenize :confirmation_token, characters: (0..9).to_a, length: 5
  tokenize :cancelation_token, length: 16

  # Relationships
  has_many :appointments, inverse_of: :offer, dependent: :destroy
  has_many :locations, through: :offer_locations
  has_many :offer_locations, inverse_of: :offer, dependent: :destroy
  has_many :offer_times, inverse_of: :offer, dependent: :destroy

  # Validations
  validates :email, presence: true, email: true, email_blacklist: true
  validates :locations, presence: true
  validates :offer_times, presence: true
  validates :phone, phone: {
    possible: false,
    allow_blank: true,
    types: :mobile
  }, presence: { if: :phone_required? }

  # Nested attributes
  accepts_nested_attributes_for :offer_times

  # Geocoding
  after_validation :execute_geocoding

  # Scopes
  scope :confirmed, -> { where.not(confirmed_at: nil) }
  scope :not_canceled, -> { where(canceled_at: nil) }

  def self.not_taken
    where('(
      SELECT COUNT(*) FROM appointments WHERE
        appointments.offer_id = offers.id AND
        appointments.canceled_at IS NULL AND
        (
          appointments.created_at > (now() - interval ?) OR
          appointments.confirmed_at IS NOT NULL
        )
    ) = 0', '2 hours')
  end

  def self.upcoming
    joins(:offer_times).where(
      'offer_times.time >= (now() + interval ?)', '6 hours')
  end

  # Attribute enhancements
  #
  def phone=(value)
    super GlobalPhone.normalize(value, :de)
  end

  # Methods
  #
  def confirm!(token, options = {})
    token_exception unless token == confirmation_token
    data = { confirmed_at: Time.zone.now }
    data[:confirmation_ip_address] = options[:ip] if options[:ip]
    update!(data)
  end

  def confirmed?
    confirmed_at.present?
  end

  def cancel!(token)
    token_exception unless token == cancelation_token
    update!(canceled_at: Time.zone.now)
  end

  def canceled?
    canceled_at.present?
  end

  def taken?
    appointments.where(canceled_at: nil).where('
      created_at > (now() - interval ?) OR confirmed_at IS NOT NULL
    ', '2 hours').exists?
  end

  def phone_required?
    locations.any? { |location| location.phone_required }
  end

  def part_one_confirmation_code
    confirmation_token[0..2]
  end

  def part_two_confirmation_code
    confirmation_token[3..5]
  end

  private

  def token_exception
    errors.add(:confirmation_token, :invalid)
    raise TokenMissmatch.new(self)
  end

  def execute_geocoding
    return if confirmation_ip_address.blank?
    result = Geocoder.search(confirmation_ip_address.to_s).first
    return unless result
    self.lng = result.longitude
    self.lat = result.latitude
    self.country = result.country
    self.city = result.city
  rescue
    nil
  end
end
