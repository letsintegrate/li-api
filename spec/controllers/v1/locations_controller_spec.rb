require 'rails_helper'

RSpec.describe V1::LocationsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
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

    it 'exposes inactive locations to users' do
      authenticate(user)
      location = FactoryGirl.create :location, active: false
      get :index
      locations = assigns(:locations)
      expect(locations).to include location
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

  describe '#create' do
    describe 'without authentication' do
      let(:data) do
        {
          type: 'locations',
          attributes: FactoryGirl.attributes_for(:location)
        }
      end

      it 'fails' do
        post :create, data: data
        expect(response).to be_unauthorized
      end
    end

    describe 'with valid data' do
      let(:data) do
        {
          type: 'locations',
          attributes: FactoryGirl.attributes_for(:location)
        }
      end

      before(:each) { authenticate(user) }

      it 'is successful' do
        post :create, data: data
        expect(response).to be_successful
      end

      it 'updates the location' do
        expect {
          post :create, data: data
        }.to change(Location, :count).by 1
      end
    end

    describe 'with invalid data' do
      let(:data) do
        {
          type: 'locations',
          attributes: FactoryGirl.attributes_for(:location, name: '')
        }
      end

      before(:each) { authenticate(user) }

      it 'is unprocessable' do
        post :create, data: data
        expect(response).to be_unprocessable
      end

      it 'is not changing the location' do
        expect {
          post :create, data: data
        }.to_not change(Location, :count)
      end
    end
  end

  describe '#show' do
    before(:each) { get :show, id: location.to_param }

    it 'is successful' do
      expect(response).to be_successful
    end
  end

  describe '#update' do
    describe 'without authentication' do
      let(:data) do
        {
          type: 'locations',
          id:   location.to_param,
          attributes: {
            description_translations: {
              de: 'hallo',
              en: 'hello'
            }
          }
        }
      end

      it 'fails' do
        patch :update, id: location.to_param, data: data
        expect(response).to be_unauthorized
      end
    end

    describe 'with valid data' do
      let(:data) do
        {
          type: 'locations',
          id:   location.to_param,
          attributes: {
            description_translations: {
              de: 'hallo',
              en: 'hello'
            }
          }
        }
      end

      before(:each) { authenticate(user) }

      it 'is successful' do
        patch :update, id: location.to_param, data: data
        expect(response).to be_successful
      end

      it 'updates the location' do
        I18n.with_locale(:en) do
          expect {
            patch :update, id: location.to_param, data: data
          }.to change { location.reload.description }.to 'hello'
        end
      end
    end

    describe 'with invalid data' do
      let(:data) do
        {
          type: 'locations',
          id:   location.to_param,
          attributes: {
            name: ''
          }
        }
      end

      before(:each) { authenticate(user) }

      it 'is unprocessable' do
        patch :update, id: location.to_param, data: data
        expect(response).to be_unprocessable
      end

      it 'is not changing the location' do
        expect {
          patch :update, id: location.to_param, data: data
        }.to_not change { location.reload.name }
      end
    end
  end

  describe '#destroy' do
    it 'fails without authentication' do
      delete :destroy, id: location.to_param
      expect(response).to be_unauthorized
    end

    it 'is successful' do
      authenticate(user)
      delete :destroy, id: location.to_param
      expect(response).to be_successful
    end

    it 'deletes the location' do
      authenticate(user)
      expect {
        delete :destroy, id: location.to_param
      }.to change(Location, :count).by -1
    end
  end
end
