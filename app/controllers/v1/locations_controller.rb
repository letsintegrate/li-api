module V1
  class LocationsController < BaseController
    before_action :set_location, only: %i(show)

    def index
      @locations = get_index(Location)
      @locations = @locations.active unless current_user
      render json: @locations, each_serializer: LocationSerializer
    end

    def show
      render json: @location, serializer: LocationSerializer
    end

    private

    def set_location
      @location = Location.find(params[:id])
    end
  end
end
