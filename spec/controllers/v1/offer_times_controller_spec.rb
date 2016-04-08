require 'rails_helper'

RSpec.describe V1::OfferTimesController, type: :controller do
  let(:offer) { FactoryGirl.create :offer, :confirmed }
  let(:offer_time) { offer.offer_times.first }
  let(:location) { offer.locations.first }

  before(:each) { offer_time }

  describe '#index' do
    before(:each) { FactoryGirl.create :offer_time, :confirmed }

    it 'is successful' do
      get :index
      expect(response).to be_successful
    end

    it 'filters by ids array' do
      ids = (1..3).map { FactoryGirl.create(:offer_time, :confirmed).id }
      get :index, ids: ids
      expect(data.length).to eql ids.length
    end

    it 'filters by ids string' do
      ids = (1..3).map { FactoryGirl.create(:offer_time, :confirmed).id }
      get :index, ids: ids.join(',')
      expect(data.length).to eql ids.length
    end

    it 'filters the result' do
      offer = FactoryGirl.create :offer, :confirmed
      get :index, filter: { offer_id_eq: offer.id }
      expect(data.length).to eql(1)
    end

    it 'only returns confirmed offers' do
      offers = FactoryGirl.create_list :offer, 3, :confirmed, locations: [location]
      offers += FactoryGirl.create_list :offer, 3, locations: [location]
      get :index, ids: offers.map(&:offer_times).flatten.map(&:id)
      expect(data.length).to eql(3)
    end

    it 'excludes taken offers' do
      offers = FactoryGirl.create_list :offer, 6, :confirmed, locations: [location]
      offers[0..2].map { |offer| FactoryGirl.create :appointment, offer: offer }
      get :index, ids: offers.map(&:offer_times).flatten.map(&:id)
      expect(data.length).to eql(3)
    end
  end

  describe '#show' do
    before(:each) { get :show, id: offer_time.to_param }

    it 'is successful' do
      expect(response).to be_successful
    end
  end
end
