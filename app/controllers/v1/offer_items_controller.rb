module V1
  class OfferItemsController < BaseController
    def index
      render json: get_index(OfferItem),
             each_serializer: OfferItemSerializer,
             include: '*'
    end
  end
end
