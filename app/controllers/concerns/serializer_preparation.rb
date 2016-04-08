# Setting the default URL options on the serializer context. This is required
# for the serializers to be able to generate link URLs.
#
module Concerns
  module SerializerPreparation
    def self.included(receiver)
      receiver.before_action do
        ActiveModelSerializers::SerializationContext.default_url_options = {
          locale: params[:locale],
          host: request.base_url
        }
      end
    end
  end
end
