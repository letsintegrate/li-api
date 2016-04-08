module V1
  class OfferTimeSerializer < BaseSerializer
    attributes :id, :time

    # Relationships
    belongs_to_link :offer
  end
end
