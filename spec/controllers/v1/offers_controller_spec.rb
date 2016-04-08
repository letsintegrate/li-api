require 'rails_helper'

RSpec.describe V1::OffersController, type: :controller do
  let(:offer)    { FactoryGirl.create :offer }
  let(:location) { FactoryGirl.create :location }

  before(:each) { offer }

  describe '#index' do
    before(:each) { FactoryGirl.create :offer }

    it 'is successful' do
      get :index
      expect(response).to be_successful
    end

    it 'filters by ids array' do
      ids = (1..3).map { FactoryGirl.create(:offer).id }
      get :index, ids: ids
      expect(data.length).to eql ids.length
    end

    it 'filters by ids string' do
      ids = (1..3).map { FactoryGirl.create(:offer).id }
      get :index, ids: ids.join(',')
      expect(data.length).to eql ids.length
    end

    it 'filters the result' do
      offer = FactoryGirl.create :offer
      get :index, filter: { offer_locations_offer_id_eq: offer.id }
      expect(data.length).to eql(1)
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
end
