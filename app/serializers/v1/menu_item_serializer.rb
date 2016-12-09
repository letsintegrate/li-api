module V1
  class MenuItemSerializer < BaseSerializer
    attributes :id, :name, :position

    # Relationships
    belongs_to_link :page
  end
end
