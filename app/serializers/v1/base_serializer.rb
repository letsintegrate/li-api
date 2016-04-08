module V1
  class BaseSerializer < ActiveModel::Serializer
    def self.has_many_link(name, options = {})
      filter     = options.delete(:filter)
      route_name = :"v1_#{name}_url"
      has_many name, options do
        include_data false
        link(:related) { send(route_name, filter: { filter => object.to_param }) }
      end
    end

    def self.belongs_to_link(name, options = {})
      route_name = :"v1_#{name}_url"
      has_one name, options do
        include_data false
        link(:related) { send(route_name, object.send(name)) }
      end
    end
  end
end
