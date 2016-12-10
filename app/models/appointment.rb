class Appointment < ActiveRecord::Base
  include Concerns::Confirmable
  include Concerns::Geocoded

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

  # Scopes
  #
  scope :upcoming, -> { joins(:offer_time).where('offer_times.time >= now()') }
  scope :valid, -> { where.not(confirmed_at: nil).where(canceled_at: nil) }

  def self.uniqueness_time_frame
    where('appointments.created_at >= ?', 1.month.ago)
  end

  def self.today
    time = Time.now.beginning_of_day..Time.now.end_of_day
    joins(:offer_time).where(offer_times: { time: time })
  end

  def self.search(value)
    if UUID.validate(value)
      where(id: value)
    else
      s = "%#{value}%"
      joins(:offer)
      .where('appointments.email ILIKE ? OR offers.email ILIKE ?', s, s)
    end
  end

  # Ransack
  #
  def self.ransackable_scopes(_auth_object = nil)
    %i(upcoming valid today search)
  end

  private

  def offer_available
    if self.offer.try(:taken?)
      errors.add(:offer, 'unavailable')
    end
  end
end
