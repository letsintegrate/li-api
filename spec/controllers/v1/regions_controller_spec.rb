require 'rails_helper'

RSpec.describe V1::RegionsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:region) { FactoryGirl.create :region }

  before(:each) { region }

  describe '#index' do
    before(:each) { FactoryGirl.create :region }

    it 'is successful' do
      get :index
      expect(response).to be_successful
    end

    it 'filters by ids array' do
      ids = (1..3).map { FactoryGirl.create(:region).id }
      get :index, ids: ids
      expect(data.length).to eql ids.length
    end

    it 'filters by ids string' do
      ids = (1..3).map { FactoryGirl.create(:region).id }
      get :index, ids: ids.join(',')
      expect(data.length).to eql ids.length
    end

    it 'filters the result' do
      offer = FactoryGirl.create :offer
      get :index, filter: { slug_eq: region.slug }
      expect(data.length).to eql(1)
    end

    it 'excludes inactive regions' do
      region = FactoryGirl.create :region, active: false
      get :index
      regions = assigns(:regions)
      expect(regions).to_not include region
    end

    it 'exposes inactive regions to users' do
      authenticate(user)
      region = FactoryGirl.create :region, active: false
      get :index
      regions = assigns(:regions)
      expect(regions).to include region
    end
  end

  describe '#create' do
    describe 'without authentication' do
      let(:data) do
        {
          type: 'regions',
          attributes: FactoryGirl.attributes_for(:region)
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
          type: 'regions',
          attributes: FactoryGirl.attributes_for(:region)
        }
      end

      before(:each) { authenticate(user) }

      it 'is successful' do
        post :create, data: data
        expect(response).to be_successful
      end

      it 'updates the region' do
        expect {
          post :create, data: data
        }.to change(Region, :count).by 1
      end
    end

    describe 'with invalid data' do
      let(:data) do
        {
          type: 'regions',
          attributes: FactoryGirl.attributes_for(:region, name: '')
        }
      end

      before(:each) { authenticate(user) }

      it 'is unprocessable' do
        post :create, data: data
        expect(response).to be_unprocessable
      end

      it 'is not changing the region' do
        expect {
          post :create, data: data
        }.to_not change(Region, :count)
      end
    end
  end

  describe '#show' do
    before(:each) { get :show, id: region.to_param }

    it 'is successful' do
      expect(response).to be_successful
    end
  end

  describe '#update' do
    describe 'without authentication' do
      let(:data) do
        {
          type: 'regions',
          id:   region.to_param,
          attributes: {
            name: ''
          }
        }
      end

      it 'fails' do
        patch :update, id: region.to_param, data: data
        expect(response).to be_unauthorized
      end
    end

    describe 'with valid data' do
      let(:data) do
        {
          type: 'regions',
          id:   region.to_param,
          attributes: {
            name: 'New name'
          }
        }
      end

      before(:each) { authenticate(user) }

      it 'is successful' do
        patch :update, id: region.to_param, data: data
        expect(response).to be_successful
      end

      it 'updates the region' do
        expect {
          patch :update, id: region.to_param, data: data
        }.to change { region.reload.name }.to 'New name'
      end
    end

    describe 'with invalid data' do
      let(:data) do
        {
          type: 'regions',
          id:   region.to_param,
          attributes: {
            name: ''
          }
        }
      end

      before(:each) { authenticate(user) }

      it 'is unprocessable' do
        patch :update, id: region.to_param, data: data
        expect(response).to be_unprocessable
      end

      it 'is not changing the region' do
        expect {
          patch :update, id: region.to_param, data: data
        }.to_not change { region.reload.name }
      end
    end
  end

  describe '#destroy' do
    it 'fails without authentication' do
      delete :destroy, id: region.to_param
      expect(response).to be_unauthorized
    end

    it 'is successful' do
      authenticate(user)
      delete :destroy, id: region.to_param
      expect(response).to be_successful
    end

    it 'deletes the region' do
      authenticate(user)
      expect {
        delete :destroy, id: region.to_param
      }.to change(Region, :count).by -1
    end
  end
end
