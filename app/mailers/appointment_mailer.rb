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
    @locale   = locale.present? ? locale : 'en'
    @location = appointment.location
    filename = Rails.root.join('public', 'locations', "#{@location.slug}.jpg")
    if File.exists?(filename)
      attachments.inline['photo.jpg'] = File.read(filename)
    end

    mail  from: "Let's integrate!<appointments+#{appointment.id}@letsintegrate.de>",
          to: [appointment.offer.email, appointment.email]
  end

  def match_admin_notification(appointment, locale = 'en')
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
