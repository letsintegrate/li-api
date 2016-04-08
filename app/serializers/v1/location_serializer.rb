module V1
  class LocationSerializer < BaseSerializer
    attributes :id, :name, :images, :slug

    # Relationships
    has_many_link :offers, filter: :offer_locations_location_id_eq
  end
end
