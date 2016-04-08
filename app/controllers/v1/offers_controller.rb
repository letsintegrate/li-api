module V1
  class OffersController < BaseController
    before_action :set_offer, only: %i(show)

    def index
      render json: get_index(Offer), each_serializer: OfferSerializer
    end

    def create
      render json: Offer.create!(offer_params.to_hash),
             serializer: OfferSerializer
    end

    def show
      render json: @offer, serializer: OfferSerializer
    end

    private

    def set_offer
      @offer = Offer.find(params[:id])
    end

    def offer_params
      whitelist = %i(offer_times_attributes location_ids)
      parameters = deserialized_params(embedded: [:offer_times])
      parameters.permit(:email).tap do |whitelisted|
        whitelist.each do |key|
          data = parameters[key]
          whitelisted[key] = data if data.present?
        end
      end
    end
  end
end
