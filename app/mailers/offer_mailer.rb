class OfferMailer < ApplicationMailer
  def confirmation(offer)
    @offer = offer

    mail to: offer.email
  end
end
