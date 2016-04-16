module V1
  class OfferSerializer < BaseSerializer
    attributes :id, :email, :confirmed

    # Relationships
    has_many_link :locations, filter: :offer_locations_offer_id_eq
    has_many_link :offer_times, filter: :offer_id_eq

    # Attributes
    def email
      ''
    end

    def confirmed
      object.confirmed?
    end
  end
end
