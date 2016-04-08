module V1
  class BaseController < ApplicationController
    include Concerns::ExceptionHandling
    include Concerns::GetIndex
    include Concerns::SerializerPreparation
    include Rails::API::HashValidationErrors

    # Deserialize JSONAPI params
    def deserialized_params(options = {})
      result = ActiveModelSerializers::Deserialization.jsonapi_parse!(params,
        options)
      ActionController::Parameters.new(result)
    end
  end
end
