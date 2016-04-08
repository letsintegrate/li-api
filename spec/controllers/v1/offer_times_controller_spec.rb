require 'rails_helper'

RSpec.describe V1::OfferTimesController, type: :controller do
  let(:offer) { FactoryGirl.create :offer }
  let(:offer_time) { offer.offer_times.first }

  before(:each) { offer_time }

  describe '#index' do
    before(:each) { FactoryGirl.create :offer_time }

    it 'is successful' do
      get :index
      expect(response).to be_successful
    end

    it 'filters by ids array' do
      ids = (1..3).map { FactoryGirl.create(:offer_time).id }
      get :index, ids: ids
      expect(data.length).to eql ids.length
    end

    it 'filters by ids string' do
      ids = (1..3).map { FactoryGirl.create(:offer_time).id }
      get :index, ids: ids.join(',')
      expect(data.length).to eql ids.length
    end

    it 'filters the result' do
      offer = FactoryGirl.create :offer
      get :index, filter: { offer_id_eq: offer.id }
      expect(data.length).to eql(1)
    end
  end

  describe '#show' do
    before(:each) { get :show, id: offer_time.to_param }

    it 'is successful' do
      expect(response).to be_successful
    end
  end
end
