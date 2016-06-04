module V1
  class LocationsController < BaseController
    before_action :set_location, only: %i(show update destroy)
    before_action :doorkeeper_authorize!, except: %i(index show)

    def index
      @locations = get_index(Location)
      @locations = @locations.active unless current_user
      render json: @locations, each_serializer: LocationSerializer
    end

    def create
      @location = Location.create!(location_params)
      render json: @location, serializer: LocationSerializer
    end

    def show
      render json: @location, serializer: LocationSerializer
    end

    def update
      @location.update!(location_params)
      render json: @location, serializer: LocationSerializer
    end

    def destroy
      @location.destroy!
      head :no_content
    end

    private

    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      whitelist = %i(description_translations)
      permitted = %i(name slug active special)
      parameters = deserialized_params
      parameters.permit(permitted).tap do |whitelisted|
        whitelist.each do |key|
          data = parameters[key]
          whitelisted[key] = data if data.present?
        end
      end
    end
  end
end
