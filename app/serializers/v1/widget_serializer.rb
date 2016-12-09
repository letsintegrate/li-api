module V1
  class WidgetSerializer < BaseSerializer
    attributes :id, :container_name, :position, :class_names

    # Relationships
    belongs_to_link :page

    # Defaults
    def class_names
      object.class_names.kind_of?(Array) ? object.class_names : []
    end
  end
end
