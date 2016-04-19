module V1
  class OfferItemSerializer < BaseSerializer
    attributes :id, :name, :time

    # Relationships
    belongs_to_link :offer
    belongs_to_link :offer_time
    belongs_to_link :location
  end
end
