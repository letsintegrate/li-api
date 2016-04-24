class OfferMailer < ApplicationMailer
  def confirmation(offer, locale = 'en')
    @offer = offer
    @locale = locale

    mail to: offer.email
  end

  def offer_list(email, locale = 'en')
    @offers = Offer.upcoming.confirmed.where(email: email)

    mail to: email
  end
end
