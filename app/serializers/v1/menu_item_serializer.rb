module V1
  class MenuItemSerializer < BaseSerializer
    attributes :id, :name

    # Relationships
    belongs_to_link :page
  end
end
