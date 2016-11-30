require "rails_helper"

RSpec.describe AppointmentMailer, type: :mailer do
  let(:location)    { FactoryGirl.create :location, slug: 'alexanderplatz' }
  let(:appointment) { FactoryGirl.create :appointment, location: location }
  let(:region)      { location.region }

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
      region.sender_email = 'appointments+%{appointment_id}@letsintegrate.de'
      region.save!
      expected = "appointments+#{appointment.id}@letsintegrate.de"
      expect(mail.from).to include(expected)
    end

    it 'is sent from the regions email address' do
      expect(mail.from).to include(region.sender_email)
    end

    context 'body' do
      subject { mail.body.encoded }

      it 'includes the location name' do
        expect(subject).to include location.name
      end
    end
  end

  describe 'cancelation_local' do
    let(:mail) { AppointmentMailer.cancelation_local(appointment) }

    it 'has a meaningful subject' do
      expect(mail.subject).to eq('Your appointment was canceled')
    end

    it 'will be send to the offers email address' do
      expect(mail.to).to eq([appointment.offer.email])
    end
  end

  describe 'cancelation_refugee' do
    let(:mail) { AppointmentMailer.cancelation_refugee(appointment) }

    it 'has a meaningful subject' do
      expect(mail.subject).to eq('Your appointment is canceled')
    end

    it 'will be send to the appointments email address' do
      expect(mail.to).to eq([appointment.email])
    end
  end

end
