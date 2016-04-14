class ReportsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reports_mailer.email_address_records.subject
  #
  def email_address_records(email)
    @offers = Offer.where(email: email)
    @appointments = Appointment.where(email: email)

    mail to: email
  end
end
