require 'rails_helper'

RSpec.describe OfferMailer, type: :mailer do
  let(:offer) { FactoryGirl.create :offer }

  describe 'confirmation' do
    let(:mail) { OfferMailer.confirmation(offer) }

    it 'has the correct subject' do
      expect(mail.subject).to eq('Confirm the e-mail address of your offer')
    end

    it 'has the correct receiver' do
      expect(mail.to).to eq([offer.email])
    end

    it 'has the correct sender' do
      expect(mail.from).to eq(['no-reply@letsintegrate.de'])
    end

    context 'body' do
      subject { mail.body.encoded }

      it 'includes the offer id' do
        expect(subject).to include offer.id
      end

      it 'includes the confirmation token' do
        expect(subject).to include offer.confirmation_token
      end
    end
  end

end
