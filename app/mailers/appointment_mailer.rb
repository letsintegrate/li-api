require 'open-uri'

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

  def match(appointment, user_locale = 'en')
    @appointment = appointment
    @locale   = user_locale.present? ? user_locale : 'en'
    @location = appointment.location
    @descriptions = {}
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        @descriptions[locale] = embed_images(appointment.location.description)
      end
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

  private

  def embed_images(html)
    doc = Nokogiri::HTML::DocumentFragment.parse(html)
    doc.css('img[src]').each do |img|
      name = File.basename(img['src'])
      if attachments[name].nil?
        attachments.inline[name] = open(img['src']).read
        img['src'] = attachments[name].url
      end
    end
    doc.to_html
  rescue
    html
  end
end
