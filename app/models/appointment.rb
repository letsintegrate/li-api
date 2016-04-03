class Appointment < ActiveRecord::Base
  tokenize :confirmation_token

  # Relationships
  belongs_to :offer_time, required: true
  belongs_to :offer, required: true

  # Validations
  validates :email, presence: true, email: true

  # Methods
  def cancel
    update!(generate_token :cancelation_token, length: 16)
    # TODO: Send e-mail
  end

  def cancel!(token)
    raise TokenMissmatch.new unless token == cancelation_token
    update!(canceled_at: Time.zone.now)
  end

  def confirm!(token)
    raise TokenMissmatch.new unless token == confirmation_token
    update!(confirmed_at: Time.zone.now)
  end
end
