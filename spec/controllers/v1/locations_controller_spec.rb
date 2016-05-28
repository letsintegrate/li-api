require 'rails_helper'

RSpec.describe V1::LocationsController, type: :controller do
  let(:location) { FactoryGirl.create :location }

  before(:each) { location }

  describe '#index' do
    before(:each) { FactoryGirl.create :location }

    it 'is successful' do
      get :index
      expect(response).to be_successful
    end

    it 'filters by ids array' do
      ids = (1..3).map { FactoryGirl.create(:location).id }
      get :index, ids: ids
      expect(data.length).to eql ids.length
    end

    it 'filters by ids string' do
      ids = (1..3).map { FactoryGirl.create(:location).id }
      get :index, ids: ids.join(',')
      expect(data.length).to eql ids.length
    end

    it 'filters the result' do
      offer = FactoryGirl.create :offer
      get :index, filter: { offers_id_eq: offer.id }
      expect(data.length).to eql(1)
    end

    it 'excludes inactive locations' do
      location = FactoryGirl.create :location, active: false
      get :index
      locations = assigns(:locations)
      expect(locations).to_not include location
    end

    context 'filtering' do
      describe '#regular' do
        it 'includes regular locations' do
          location = FactoryGirl.create :location
          get :index
          locations = assigns(:locations)
          expect(locations).to include location
        end

        it 'excludes special locations' do
          location = FactoryGirl.create :location, special: true
          get :index, filter: { regular: true }
          locations = assigns(:locations)
          expect(locations).to_not include location
        end
      end
    end
  end

  describe '#show' do
    before(:each) { get :show, id: location.to_param }

    it 'is successful' do
      expect(response).to be_successful
    end
  end
end
