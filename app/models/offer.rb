class Offer < ActiveRecord::Base
  tokenize :confirmation_token, length: 16

  # Relationships
  has_many :appointments, inverse_of: :offer
  has_many :locations, through: :offer_locations
  has_many :offer_locations, inverse_of: :offer
  has_many :offer_times, inverse_of: :offer

  # Validations
  validates :email, presence: true, email: true
  validates :locations, presence: true
  validates :offer_times, presence: true

  # Nested attributes
  accepts_nested_attributes_for :offer_times

  # Scopes
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  def self.not_taken
    where('(
      SELECT COUNT(*) FROM appointments WHERE
        appointments.offer_id = offers.id AND
        (
          appointments.created_at > ? OR
          appointments.confirmed_at IS NOT NULL
        )
    ) = 0', 2.hours.ago)
  end

  # Methods
  def confirm!(token)
    token_exception unless token == confirmation_token
    update!(confirmed_at: Time.zone.now)
  end

  def confirmed?
    confirmed_at.present?
  end

  private

  def token_exception
    errors.add(:confirmation_token, :invalid)
    raise TokenMissmatch.new(self)
  end
end
