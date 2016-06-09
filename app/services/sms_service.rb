class SmsService
  class DummyClient
    def send_message(options)
      puts "* From: #{options[:from]}"
      puts "* To:   #{options[:to]}"
      puts "* Text: #{options[:text]}"
    end
  end

  def self.send_sms(offer)
    klass  = Rails.env.production? ? Nexmo::Client : DummyClient
    client = klass.new
    client.send_message(
      from: 'Let\'s integrate!',
      to: offer.phone,
      text: "Part one confirmation code: #{offer.part_one_confirmation_code}"
    )
  end
end
