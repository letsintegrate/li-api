require 'rails_helper'

RSpec.describe V1::UsersController, type: :controller do
  let(:user)    { FactoryGirl.create :user }

  before(:each) { authenticate(user) }

  describe '#index' do
    before(:each) { FactoryGirl.create :user }

    it 'is successful' do
      get :index
      expect(response).to be_successful
    end

    it 'filters by ids array' do
      ids = (1..3).map { FactoryGirl.create(:user).id }
      get :index, ids: ids
      expect(data.length).to eql ids.length
    end

    it 'filters by ids string' do
      ids = (1..3).map { FactoryGirl.create(:user).id }
      get :index, ids: ids.join(',')
      expect(data.length).to eql ids.length
    end

    it 'filters the result' do
      user = FactoryGirl.create :user
      get :index, filter: { id_eq: user.id }
      expect(data.length).to eql(1)
    end
  end

  describe '#create' do
    describe 'with valid data' do
      let(:data) do
        {
          type: 'users',
          attributes: FactoryGirl.attributes_for(:user)
        }
      end

      it 'is successful' do
        post :create, data: data
        expect(response).to be_successful
      end

      it 'creates a new user' do
        expect {
          post :create, data: data
        }.to change(User, :count).by 1
      end
    end

    describe 'with invalid data' do
      let(:data) do
        {
          type: 'users',
          attributes: FactoryGirl.attributes_for(:user, email: '')
        }
      end

      it 'is unprocessable' do
        post :create, data: data
        expect(response).to be_unprocessable
      end

      it 'is not creating a user' do
        expect {
          post :create, data: data
        }.to_not change(User, :count)
      end
    end
  end

  describe '#show' do
    before(:each) { get :show, id: user.to_param }

    it 'is successful' do
      expect(response).to be_successful
    end
  end

  describe '#me' do
    before(:each) { get :me }

    it 'is successful' do
      expect(response).to be_successful
    end
  end

  describe '#update' do
    describe 'with valid data' do
      let(:data) do
        {
          type: 'users',
          id:   user.to_param,
          attributes: {
            password: 'another password'
          }
        }
      end

      it 'is successful' do
        patch :update, id: user.to_param, data: data
        expect(response).to be_successful
      end

      it 'updates the user' do
        expect {
          patch :update, id: user.to_param, data: data
        }.to change { user.reload.password_digest }
      end
    end

    describe 'with invalid data' do
      let(:data) do
        {
          type: 'users',
          id:   user.to_param,
          attributes: {
            password: 'x'
          }
        }
      end

      it 'is unprocessable' do
        patch :update, id: user.to_param, data: data
        expect(response).to be_unprocessable
      end

      it 'is not changing the user' do
        expect {
          patch :update, id: user.to_param, data: data
        }.to_not change { user.reload.password_digest }
      end
    end
  end

  describe '#destroy' do
    it 'is successful' do
      delete :destroy, id: user.to_param
      expect(response).to be_successful
    end

    it 'creates a new user' do
      expect {
        delete :destroy, id: user.to_param
      }.to change(User, :count).by -1
    end
  end
end
