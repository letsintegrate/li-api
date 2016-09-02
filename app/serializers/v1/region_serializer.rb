module V1
  class RegionSerializer < BaseSerializer
    attributes :id, :country, :name, :slug, :active, :sender_email

    # Relationships
    has_many_link :locations, filter: :region_id_eq
  end
end
