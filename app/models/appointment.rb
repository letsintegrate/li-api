class Appointment < ActiveRecord::Base
  tokenize :confirmation_token, characters: (0..9).to_a, length: 5
  tokenize :cancelation_token

  # Relationships
  belongs_to :location, required: true
  belongs_to :offer_time, required: true
  belongs_to :offer, required: true

  # Validations
  validates :email, presence: true, email: true, email_blacklist: true
  validate  :offer_available, on: :create

  # Methods
  def cancel!(token)
    token_exception unless token == cancelation_token
    update!(canceled_at: Time.zone.now)
  end

  def confirm!(token)
    token_exception unless token == confirmation_token
    data = { confirmed_at: Time.zone.now }
    data[:confirmation_ip_address] = options[:ip] if options[:ip]
    update!(data)
  end

  def confirmed?
    confirmed_at.present?
  end

  private

  def token_exception
    errors.add(:confirmation_token, :invalid)
    raise TokenMissmatch.new(self)
  end

  def offer_available
    if self.offer.try(:taken?)
      errors.add(:offer, 'unavailable')
    end
  end
end
