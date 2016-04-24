class AppointmentMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.appointment_mailer.confirmation.subject
  #
  def confirmation(appointment, locale = 'en')
    @appointment = appointment
    @locale = locale.present? ? locale : 'en'

    mail to: appointment.email
  end

  def match(appointment, locale = 'en')
    @appointment = appointment
    @locale = locale.present? ? locale : 'en'

    mail to: 'appointments@letsintegrate.de'
  end
end
