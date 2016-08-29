class OfferTime < ActiveRecord::Base
  # Relationships
  belongs_to :offer, required: true, inverse_of: :offer_times

  # Validations
  validates :time, presence: true

  # Scopes
  scope :confirmed, -> { joins(:offer).where.not(offers: { confirmed_at: nil}) }
  scope :not_canceled, -> { joins(:offer).where(offers: { canceled_at: nil}) }

  def self.not_taken
    joins(:offer).where('(
      SELECT COUNT(*) FROM appointments WHERE
        appointments.offer_id = offers.id AND
        appointments.canceled_at IS NULL AND
        (
          appointments.created_at > (now() - interval ?) OR
          appointments.confirmed_at IS NOT NULL
        )
    ) = 0', '2 hours')
  end

  def self.location(id)
    joins(offer: [:offer_locations]).where(offer_locations: {
      location_id: id
    })
  end

  def self.upcoming
    where('offer_times.time >= (now() + interval ?)', '24 hours')
  end

  # `ransackable_scopes` by default returns an empty array
  # i.e. no class methods/scopes are authorized.
  # For overriding with a whitelist array of *symbols*.
  #
  def self.ransackable_scopes(_auth_object = nil)
    %i(location)
  end
end
