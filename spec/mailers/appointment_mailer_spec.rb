require "rails_helper"

RSpec.describe AppointmentMailer, type: :mailer do
  let(:appointment) { FactoryGirl.create :appointment }

  describe "confirmation" do
    let(:mail) { AppointmentMailer.confirmation(appointment) }

    it 'has the correct subject' do
      expect(mail.subject).to eq('Confirm the e-mail address')
    end

    it 'has the correct receiver' do
      expect(mail.to).to eq([appointment.email])
    end

    it 'has the correct sender' do
      expect(mail.from).to eq(['no-reply@letsintegrate.de'])
    end

    context 'body' do
      subject { mail.body.encoded }

      it 'includes the offer id' do
        expect(subject).to include appointment.id
      end

      it 'includes the confirmation token' do
        expect(subject).to include appointment.confirmation_token
      end
    end
  end

end
