module V1
  class OfferItemsController < BaseController
    before_action :set_offer_item, only: %i(show)

    def index
      @offer_items = get_index(OfferItem, destinct: false)
      render json: @offer_items,
             each_serializer: OfferItemSerializer,
             include: '*'
    end

    def show
      render json: @offer_item, serializer: OfferItemSerializer
    end

    private

    def set_offer_item
      @offer_item = OfferItem.find(params[:id])
    end
  end
end
