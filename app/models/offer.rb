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

  # Nested attributes
  accepts_nested_attributes_for :offer_times

  # Geocoding
  geocoded_by :confirmation_ip_address,
    latitude: :lat, longitude: :lng, country: :country, city: :city
  after_validation :geocode

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
      'offer_times.time >= (now() + interval ?)', '24 hours')
  end

  # Methods
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

  private

  def token_exception
    errors.add(:confirmation_token, :invalid)
    raise TokenMissmatch.new(self)
  end

  def geocode
    do_lookup(false) do |o,rs|
      if r = rs.first
        unless r.latitude.nil? or r.longitude.nil?
          o.__send__  "#{self.class.geocoder_options[:latitude]}=",  r.latitude
          o.__send__  "#{self.class.geocoder_options[:longitude]}=", r.longitude
          o.__send__  "#{self.class.geocoder_options[:country]}=",   r.country
          o.__send__  "#{self.class.geocoder_options[:city]}=",      r.city
        end
        r.coordinates
      end
    end
  end
end
