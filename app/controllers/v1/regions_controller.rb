module V1
  class RegionsController < BaseController
    before_action :set_region, only: %i(show update destroy)
    before_action :doorkeeper_authorize!, except: %i(index show)

    def index
      @regions = get_index(Region)
      @regions = @regions.active unless current_user
      render json: @regions, each_serializer: RegionSerializer
    end

    def create
      @region = Region.create!(region_params)
      render json: @region, serializer: RegionSerializer
    end

    def show
      render json: @region, serializer: RegionSerializer
    end

    def update
      @region.update!(region_params)
      render json: @region, serializer: RegionSerializer
    end

    def destroy
      @region.destroy!
      head :no_content
    end

    private

    def set_region
      @region = Region.find(params[:id])
    end

    def region_params
      whitelist = %i()
      permitted = %i(active country name sender_email slug)
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
