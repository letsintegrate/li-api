module Concerns
  module ResourceController
    extend ActiveSupport::Concern

    included do
      cattr_accessor :resource_scope

      before_action :set_resource,     only: %i(show update destroy)
      before_action :apply_id_filters, only: :index
    end

    def index
      @resources = policy_scope(resource_scope).ransack(params[:filter])
                                               .result(distinct: true)
      @resources = @resources.limit(limit) if limit > 0

      render json: @resources, each_serializer: resource_serializer
    end

    def show
      render json: @resource, serializer: resource_serializer
    end

    def create
      @resource = resource_scope.new(resource_params)
      authorize @resource
      @resource.save!
      render json: @resource, serializer: resource_serializer
    end

    def update
      @resource.assign_attributes(resource_params)
      authorize @resource
      @resource.save!
      render json: @resource, serializer: resource_serializer
    end

    def destroy
      @resource.destroy
      head :no_content
    end

    private

    def set_resource
      @resource = policy_scope(resource_scope).find params[:id]
      authorize @resource
    end

    def resource_param_name
      @resource_param_name ||= resource_scope.class_name.underscore.to_sym
    end

    def resource_params
      return @resource_params if @resource_params

      object        = @resource || resource_scope
      object_policy = policy(object)
      permitted_attributes   = object_policy.permitted_attributes
      whitelisted_attributes = object_policy.whitelisted_attributes
      resource_params  = deserialized_params
      @resource_params = resource_params
                         .permit(permitted_attributes)
                         .tap do |whitelisted|
                           whitelisted_attributes.each do |key|
                             data = resource_params[key]
                             whitelisted[key] = data if data.present?
                           end
                         end
    end

    def resource_serializer
      "V1::#{resource_scope.class_name}Serializer".constantize
    end

    def apply_id_filters
      params[:filter] ||= {}

      if params.has_key? :ids
        ids = params[:ids]
        ids = ids.split(',') if ids.kind_of? String
        params[:filter][:id_in] = ids if ids.kind_of? Array
      end
    end

    def limit
      Integer(params[:limit] || 0)
    end
  end
end
