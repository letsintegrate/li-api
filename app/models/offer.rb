class Offer < ActiveRecord::Base
  tokenize :confirmation_token, length: 16

  # Relationships
  has_many :locations, through: :offer_locations
  has_many :offer_locations, inverse_of: :offer
  has_many :offer_times, inverse_of: :offer

  # Validations
  validates :email, presence: true, email: true
  validates :locations, presence: true
  validates :offer_times, presence: true

  # Nested attributes
  accepts_nested_attributes_for :offer_times

  # Methods
  def confirm!(token)
    raise TokenMissmatch.new unless token == confirmation_token
    update!(confirmed_at: Time.zone.now)
  end
end
