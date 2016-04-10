class OfferMailer < ApplicationMailer
  def confirmation(offer)
    @offer = offer

    mail to: offer.email
  end

  def offer_list(email)
    @offers = Offer.upcoming.confirmed.where(email: email)

    mail to: email
  end
end
