class ReportsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reports_mailer.email_address_records.subject
  #
  def email_address_records(email, locale = 'en')
    @offers = Offer.where(email: email)
    @appointments = Appointment.where(email: email)
    @locale = locale.present? ? locale : 'en'

    mail to: email
  end
end
