class OfferItem < ActiveRecord::Base
  self.primary_key = 'id'

  # Relationships
  belongs_to :location
  belongs_to :offer_time
  belongs_to :offer
end
