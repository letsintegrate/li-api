module V1
  class OffersController < BaseController
    before_action :set_offer, only: %i(show)

    def index
      @offers = get_index(Offer).upcoming.confirmed.not_taken.not_canceled
      render json: @offers, each_serializer: OfferSerializer
    end

    def create
      @offer = Offer.create!(offer_params)
      OfferMailer.confirmation(@offer, locale).deliver_now
      render json: @offer, serializer: OfferSerializer
    end

    def show
      render json: @offer, serializer: OfferSerializer
    end

    def confirm
      @offer = Offer.find(params[:id])
      verify_recaptcha!(@offer)
      @offer.confirm!(params[:token])
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
      end.to_hash.merge(locale: I18n.locale)
    end
  end
end
