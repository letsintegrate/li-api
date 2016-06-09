require 'rails_helper'

RSpec.describe V1::OffersController, type: :controller do
  let(:offer)    { FactoryGirl.create :offer, :confirmed, :upcoming }
  let(:location) { FactoryGirl.create :location }

  before(:each) { offer }

  describe '#index' do
    before(:each) { FactoryGirl.create :offer, :confirmed, :upcoming }

    it 'is successful' do
      get :index
      expect(response).to be_successful
    end

    it 'filters by ids array' do
      ids = (1..3).map { FactoryGirl.create(:offer, :confirmed, :upcoming).id }
      get :index, ids: ids
      expect(data.length).to eql ids.length
    end

    it 'filters by ids string' do
      ids = (1..3).map { FactoryGirl.create(:offer, :confirmed, :upcoming).id }
      get :index, ids: ids.join(',')
      expect(data.length).to eql ids.length
    end

    it 'filters the result' do
      offer = FactoryGirl.create :offer, :confirmed, :upcoming
      get :index, filter: { offer_locations_offer_id_eq: offer.id }
      expect(data.length).to eql(1)
    end

    it 'only returns confirmed offers' do
      offers = FactoryGirl.create_list :offer, 3, :confirmed, :upcoming, locations: [location]
      offers += FactoryGirl.create_list :offer, 3, :upcoming, locations: [location]
      get :index, ids: offers.map(&:id)
      expect(data.length).to eql(3)
    end

    it 'excludes taken offers' do
      offers = FactoryGirl.create_list :offer, 6, :confirmed, :upcoming, locations: [location]
      offers[0..2].map { |offer| FactoryGirl.create :appointment, offer: offer }
      get :index, ids: offers.map(&:id)
      expect(data.length).to eql(3)
    end

    it 'includes upcoming offers' do
      offer = FactoryGirl.create :offer, :confirmed, :upcoming
      get :index, ids: offer.id
      expect(response.body).to include offer.id
    end

    it 'excludes expired offers' do
      offer = FactoryGirl.create :offer, :confirmed, :expired
      get :index, ids: offer.id
      expect(response.body).to_not include offer.id
    end

    it 'excludes canceled offers' do
      offer = FactoryGirl.create :offer, :confirmed, :upcoming, :canceled
      get :index, ids: offer.id
      expect(response.body).to_not include offer.id
    end
  end

  describe '#create' do
    describe 'with valid data' do
      let(:data) do
        {
          type: 'articles',
          attributes: {
            email: FFaker::Internet.email
          },
          relationships: {
            locations: {
              data: [{
                type: 'locations',
                id: location.id
              }]
            },
            'offer_times': {
              data: [{
                type: 'offer-times',
                attributes: FactoryGirl.attributes_for(:offer_time)
              }]
            }
          }
        }
      end

      it 'is successful' do
        post :create, data: data
        expect(response).to be_successful
      end

      it 'creates a new offer' do
        expect {
          post :create, data: data
        }.to change(Offer, :count).by 1
      end

      it 'calls OfferMailer#confirmation' do
        @request.env['HTTP_X_LOCALE'] = 'en'
        expect(OfferMailer).to receive(:confirmation)
          .with(Offer, 'en')
          .and_return(OfferMailer.confirmation(offer))
        post :create, data: data
      end

      it 'sends an e-Mail' do
        expect {
          post :create, data: data
        }.to change { OfferMailer.deliveries.count }.by(1)
      end

      it 'stores the X-Locale header at the offer' do
        request.headers['HTTP_X_LOCALE'] = 'ar'
        post :create, data: data
        offer = assigns(:offer)
        expect(offer.locale).to eql('ar')
      end

      describe 'with phone required location' do
        let(:location) { FactoryGirl.create :location, :phone_required }
        let(:data) do
          {
            type: 'articles',
            attributes: {
              email: FFaker::Internet.email,
              phone: '01771234567'
            },
            relationships: {
              locations: {
                data: [{
                  type: 'locations',
                  id: location.id
                }]
              },
              'offer_times': {
                data: [{
                  type: 'offer-times',
                  attributes: FactoryGirl.attributes_for(:offer_time)
                }]
              }
            }
          }
        end

        it 'sends an SMS if the location requires a phone number' do
          expect(SmsService).to receive(:send_sms)
          post :create, data: data
        end
      end
    end

    describe 'with invalid data' do
      let(:data) do
        {
          type: 'articles',
          attributes: FactoryGirl.attributes_for(:offer, email: '')
        }
      end

      it 'is unprocessable' do
        post :create, data: data
        expect(response).to be_unprocessable
      end

      it 'is not creating a offer' do
        expect {
          post :create, data: data
        }.to_not change(Offer, :count)
      end
    end
  end

  describe '#show' do
    before(:each) { get :show, id: offer.to_param }

    it 'is successful' do
      expect(response).to be_successful
    end
  end

  describe '#confirm' do
    let(:offer) { FactoryGirl.create :offer }

    it 'is successful' do
      patch :confirm, id: offer.to_param, token: offer.confirmation_token
      expect(response).to be_successful
    end

    it 'confirms the record' do
      expect {
        patch :confirm, id: offer.to_param, token: offer.confirmation_token
      }.to change { offer.reload.confirmed? }.from(false).to true
    end

    it 'fails with wrong confirmation token' do
      patch :confirm, id: offer.to_param, token: 'foo'
      expect(response).to be_unprocessable
    end
  end
end
