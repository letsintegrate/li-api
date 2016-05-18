module V1
  class OfferItemsController < BaseController
    def index
      @offer_items = get_index(OfferItem)
      render json: @offer_items,
             each_serializer: OfferItemSerializer,
             include: '*'
    end
  end
end
