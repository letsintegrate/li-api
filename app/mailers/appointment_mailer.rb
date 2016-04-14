class AppointmentMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.appointment_mailer.confirmation.subject
  #
  def confirmation(appointment)
    @appointment = appointment

    mail to: appointment.email
  end

  def match(appointment)
    @appointment = appointment

    mail to: 'appointments@letsintegrate.de'
  end
end
