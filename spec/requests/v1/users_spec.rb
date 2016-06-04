require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { FactoryGirl.create :user }
  let(:application) { FactoryGirl.create :application }
  let(:token) { Doorkeeper::AccessToken.create application: application, resource_owner_id: user.id }
  let(:authorization) { "Bearer #{token.token}" }

  before(:each) { user }

  describe "#index" do
    it "works" do
      get v1_users_path, nil, authorization: authorization
      expect(response).to have_http_status(200)
    end

    it "is forbidden without authorization" do
      get v1_users_path
      expect(response).to be_unauthorized
    end

    it "works with ids parameter" do
      get v1_users_path(ids: user.to_param), nil, authorization: authorization
      expect(response).to have_http_status(200)
    end

    it "works with filters" do
      user = FactoryGirl.create :user
      get v1_users_path(filter: { id_eq: user.id }), nil, authorization: authorization
      expect(response).to have_http_status(200)
    end
  end

  describe '#create' do
    it 'works' do
      data = {
        type: 'users',
        attributes: FactoryGirl.attributes_for(:user)
      }
      post v1_users_path, { data: data }, authorization: authorization
      expect(response).to be_successful
    end

    it "is forbidden without authorization" do
      data = {
        type: 'users',
        attributes: FactoryGirl.attributes_for(:user)
      }
      post v1_users_path, data: data
      expect(response).to be_unauthorized
    end

    it 'is unprocessable' do
      data = {
        type: 'users',
        attributes: FactoryGirl.attributes_for(:user, email: '')
      }
      post v1_users_path, { data: data }, authorization: authorization
      expect(response).to be_unprocessable
    end
  end

  describe '#show' do
    it 'works' do
      get v1_user_path(id: user.id), nil, authorization: authorization
      expect(response).to have_http_status(200)
    end

    it "is forbidden without authorization" do
      get v1_user_path(id: user.id)
      expect(response).to be_unauthorized
    end
  end

  describe '#me' do
    it 'works' do
      get me_v1_users_path, nil, authorization: authorization
      expect(response).to have_http_status(200)
    end

    it "is forbidden without authorization" do
      get me_v1_users_path
      expect(response).to be_unauthorized
    end
  end

  describe '#update' do
    it 'works' do
      data = {
        type: 'users',
        attributes: {
          password: 'Some very secret password'
        }
      }
      patch v1_user_path(id: user.id), { data: data }, authorization: authorization
      expect(response).to be_successful
    end

    it "is forbidden without authorization" do
      data = {
        type: 'users',
        attributes: {
          password: 'Some very secret password'
        }
      }
      patch v1_user_path(id: user.id), data: data
      expect(response).to be_unauthorized
    end

    it 'is unprocessable' do
      data = {
        type: 'users',
        attributes: {
          password: 'x'
        }
      }
      patch v1_user_path(id: user.id), { data: data }, authorization: authorization
      expect(response).to be_unprocessable
    end
  end

  describe '#destroy' do
    it 'works' do
      delete v1_user_path(id: user.id), nil, authorization: authorization
      expect(response).to be_successful
    end

    it "is forbidden without authorization" do
      delete v1_user_path(id: user.id)
      expect(response).to be_unauthorized
    end
  end
end
