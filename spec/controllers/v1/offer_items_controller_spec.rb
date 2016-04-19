require 'rails_helper'

RSpec.describe V1::OfferItemsController, type: :controller do
  let(:offer) { FactoryGirl.create :offer, :confirmed, :upcoming }
  let(:offer_time) { offer.offer_times.first }
  let(:location) { offer.locations.first }

  before(:each) { offer_time }

  describe '#index' do
    before(:each) { FactoryGirl.create :offer_time, :confirmed, :upcoming }

    it 'is successful' do
      get :index
      expect(response).to be_successful
    end

    it 'filters the result' do
      offer = FactoryGirl.create :offer, :confirmed, :upcoming
      get :index, filter: { location_id_eq: offer.locations.first.id }
      expect(data.length).to eql(1)
    end

    it 'only returns confirmed offers' do
      Offer.destroy_all
      offers = FactoryGirl.create_list :offer, 3, :confirmed, :upcoming, locations: [location]
      offers += FactoryGirl.create_list :offer, 3, :upcoming, locations: [location]
      get :index
      expect(data.length).to eql(3)
    end
  end
end
