module V1
  class BaseController < ApplicationController
    include Concerns::ExceptionHandling
    include Concerns::GetIndex
    include Concerns::Locale
    include Concerns::SerializerPreparation
    include Rails::API::HashValidationErrors
    include Recaptcha::Verify

    # Deserialize JSONAPI params
    def deserialized_params(options = {})
      result = ActiveModelSerializers::Deserialization.jsonapi_parse!(params,
        options)
      ActionController::Parameters.new(result)
    end

    def verify_recaptcha!(model)
      unless verify_recaptcha(response: params[:recaptcha], model: model)
        raise ActiveRecord::RecordNotSaved.new('invalid recaptcha', model)
      end
    end

    def render(options = {})
      if options.has_key?(:serializer) || options.has_key?(:each_serializer)
        options.reverse_merge!(
          admin?: current_user.present?
        )
      end
      super(options)
    end
  end
end
