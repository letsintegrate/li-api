class Offer < ActiveRecord::Base
  include Concerns::Confirmable
  include Concerns::Geocoded

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
      'offer_times.time >= (now() + interval ?)', '1 hours')
  end

  # Attribute enhancements
  #
  def phone=(value)
    super GlobalPhone.normalize(value, :de)
  end

  # Methods
  #
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
end
