class Appointment < ActiveRecord::Base
  tokenize :confirmation_token, characters: (0..9).to_a, length: 5
  tokenize :cancelation_token

  # Relationships
  belongs_to :location, required: true
  belongs_to :offer_time, required: true
  belongs_to :offer, required: true

  # Validations
  validates :email, presence: true,
                    email: true,
                    email_blacklist: true,
                    uniqueness: {
                      conditions: -> { uniqueness_time_frame }
                    }
  validate  :offer_available, on: :create

  # Geocoding
  after_validation :execute_geocoding

  # Scopes
  #
  scope :upcoming, -> { joins(:offer_time).where('offer_times.time >= now()') }
  scope :valid, -> { where.not(confirmed_at: nil).where(canceled_at: nil) }

  def self.uniqueness_time_frame
    where('appointments.created_at >= ?', 1.week.ago)
  end

  def self.today
    time = Time.now.beginning_of_day..Time.now.end_of_day
    joins(:offer_time).where(offer_times: { time: time })
  end

  def self.search(value)
    if /^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i =~ value
      where(id: value)
    else
      s = "%#{value}%"
      joins(:offer)
      .where('appointments.email ILIKE ? OR offers.email ILIKE ?', s, s)
    end
  end

  # Ransack
  #
  def self.ransackable_scopes(auth_object = nil)
    %i(upcoming valid today search)
  end

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
