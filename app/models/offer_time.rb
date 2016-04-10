class OfferTime < ActiveRecord::Base
  # Relationships
  belongs_to :offer, required: true, inverse_of: :offer_times

  # Validations
  validates :time, presence: true

  # Scopes
  scope :confirmed, -> { joins(:offer).where.not(offers: { confirmed_at: nil}) }

  def self.not_taken
    joins(:offer).where('(
      SELECT COUNT(*) FROM appointments WHERE
        appointments.offer_id = offers.id AND
        (
          appointments.created_at > ? OR
          appointments.confirmed_at IS NOT NULL
        )
    ) = 0', 2.hours.ago)
  end

  def self.location(id)
    joins(offer: [:offer_locations]).where(offer_locations: {
      location_id: id
    })
  end

  def self.upcoming
    where('offer_times.time >= ?', Time.zone.now)
  end
end