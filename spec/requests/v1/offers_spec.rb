require 'rails_helper'

RSpec.describe "Offers", type: :request do
  let(:offer) { FactoryGirl.create :offer, :confirmed }
  let(:location) { FactoryGirl.create :location }

  before(:each) { offer }

  describe "#index" do
    it "works" do
      get v1_offers_path
      expect(response).to have_http_status(200)
    end

    it "works with ids parameter" do
      get v1_offers_path(ids: offer.to_param)
      expect(response).to have_http_status(200)
    end

    it "works with filters" do
      location = FactoryGirl.create :location
      get v1_offers_path(filter: { offer_locations_location_id_eq: location.id })
      expect(response).to have_http_status(200)
    end
  end

  describe '#create' do
    it 'works' do
      data = {
        type: 'offers',
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
      post v1_offers_path, data: data
      expect(response).to be_successful
    end

    it 'is unprocessable' do
      data = {
        type: 'offers',
        attributes: {
          email: ''
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
      post v1_offers_path, data: data
      expect(response).to be_unprocessable
    end
  end

  describe '#show' do
    it 'works' do
      get v1_offer_path(id: offer.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#confirm' do
    it 'works' do
      patch confirm_v1_offer_path(id: offer.id, token: offer.confirmation_token)
      expect(response).to have_http_status(200)
    end

    it 'fails with invalid token' do
      patch confirm_v1_offer_path(id: offer.id, token: 'foo')
      expect(response).to be_unprocessable
    end
  end
end
