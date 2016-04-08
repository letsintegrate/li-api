module V1
  class OfferSerializer < BaseSerializer
    attributes :id, :email

    # Relationships
    has_many_link :locations, filter: :offer_locations_offer_id_eq
    has_many_link :offer_times, filter: :location_id_eq

    # Attributes
    def email
      ''
    end
  end
end
