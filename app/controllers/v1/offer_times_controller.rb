module V1
  class OfferTimesController < BaseController
    before_action :set_offer_time, only: %i(show)

    def index
      @offer_times = get_index(OfferTime).confirmed.not_taken
      render json: @offer_times, each_serializer: OfferTimeSerializer
    end

    def show
      render json: @offer_time, serializer: OfferTimeSerializer
    end

    private

    def set_offer_time
      @offer_time = OfferTime.find(params[:id])
    end
  end
end
