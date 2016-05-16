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

  # Geocoding
  geocoded_by :confirmation_ip_address,
    latitude: :lat, longitude: :lng, country: :country, city: :city
  after_validation :geocode

  # Methods
  def cancel!(token)
    token_exception unless token == cancelation_token
    update!(canceled_at: Time.zone.now)
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

  def offer_available
    if self.offer.try(:taken?)
      errors.add(:offer, 'unavailable')
    end
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
