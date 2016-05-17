require "rails_helper"

RSpec.describe AppointmentMailer, type: :mailer do
  let(:location)    { FactoryGirl.create :location, slug: 'alexanderplatz' }
  let(:appointment) { FactoryGirl.create :appointment, location: location }

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

  describe 'match' do
    let(:mail) { AppointmentMailer.match(appointment) }

    it 'has a meaningful subject' do
      expect(mail.subject).to eq('It\'s a match!')
    end

    it 'contains the offer email as a receiver' do
      expect(mail.to).to include(appointment.offer.email)
    end

    it 'contains the appointment email as a receiver' do
      expect(mail.to).to include(appointment.email)
    end

    it 'is sent from appointments+[appointment-id]@letsintegrate.de' do
      expected = "appointments+#{appointment.id}@letsintegrate.de"
      expect(mail.from).to include(expected)
    end

    context 'body' do
      subject { mail.body.encoded }

      it 'includes the location name' do
        expect(subject).to include location.name
      end
    end
  end

end
