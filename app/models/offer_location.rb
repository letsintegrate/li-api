class OfferLocation < ActiveRecord::Base
  # Relationships
  belongs_to :location, required: true
  belongs_to :offer, required: true
end
