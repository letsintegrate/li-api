module Concerns
  module Confirmable
    def cancel!(token)
      token_exception unless token == cancelation_token
      update!(canceled_at: Time.zone.now)
    end

    def canceled?
      canceled_at.present?
    end

    def confirm!(token, options = {})
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
  end
end
