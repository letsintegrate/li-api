module V1
  class OfferSerializer < BaseSerializer
    attributes :id, :email, :confirmed, :phone_required

    # Relationships
    has_many_link :locations, filter: :offer_locations_offer_id_eq
    has_many_link :offer_times, filter: :offer_id_eq

    # Attributes
    def email
      instance_options[:admin?] ? object.email : ''
    end

    def confirmed
      object.confirmed?
    end

    def phone_required
      object.phone_required?
    end
  end
end
