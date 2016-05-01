class Offer < ActiveRecord::Base
  tokenize :confirmation_token, characters: (0..9).to_a, length: 5
  tokenize :cancelation_token, length: 16

  # Relationships
  has_many :appointments, inverse_of: :offer, dependent: :destroy
  has_many :locations, through: :offer_locations
  has_many :offer_locations, inverse_of: :offer, dependent: :destroy
  has_many :offer_times, inverse_of: :offer, dependent: :destroy

  # Validations
  validates :email, presence: true, email: true
  validates :locations, presence: true
  validates :offer_times, presence: true

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
      'offer_times.time >= (now() + interval ?)', '24 hours')
  end

  # Methods
  def confirm!(token)
    token_exception unless token == confirmation_token
    update!(confirmed_at: Time.zone.now)
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

  private

  def token_exception
    errors.add(:confirmation_token, :invalid)
    raise TokenMissmatch.new(self)
  end
end
