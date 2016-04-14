require "rails_helper"

RSpec.describe ReportsMailer, type: :mailer do
  describe "email_address_records" do
    let(:email) { FFaker::Internet.email }
    let(:mail) { ReportsMailer.email_address_records(email) }

    let(:offer) { FactoryGirl.create :offer, email: email }
    let(:appointment) { FactoryGirl.create :appointment, email: email }

    it 'renders the subject' do
      expect(mail.subject).to eql('Your report from Let\'s integrate')
    end

    it 'is sent to the correct email address' do
      expect(mail.to).to eql([email])
    end

    it 'is is sent from letsintegrate' do
      expect(mail.from).to eq(['no-reply@letsintegrate.de'])
    end

    context 'body' do
      subject { mail.body.encoded }

      it 'contains the offers' do
        offer
        expect(subject).to include offer.id
      end

      it 'contains the appointments' do
        appointment
        expect(subject).to include appointment.id
      end
    end
  end

end
