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

  def remind_local(appointment)
    I18n.with_locale(appointment.offer.locale) do
      @appointment = appointment

      mail to: appointment.offer.email
    end
  end

  def remind_refugee(appointment)
    I18n.with_locale(appointment.locale) do
      @appointment = appointment

      mail to: appointment.email
    end
  end
end
