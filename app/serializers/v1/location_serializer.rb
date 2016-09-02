module V1
  class LocationSerializer < BaseSerializer
    attributes :id, :name, :images, :slug, :active, :special,
      :description_translations, :new_images, :images, :phone_required

    # Relationships
    belongs_to :region
    has_many_link :offers, filter: :offer_locations_location_id_eq
  end
end
