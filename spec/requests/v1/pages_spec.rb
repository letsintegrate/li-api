require 'rails_helper'

RSpec.describe "Pages", type: :request do
  let(:user) { FactoryGirl.create :user }
  let(:application) { FactoryGirl.create :application }
  let(:token) { Doorkeeper::AccessToken.create application: application, resource_owner_id: user.id }
  let(:authorization) { "Bearer #{token.token}" }
  let(:page) { FactoryGirl.create :page }

  before(:each) { page }

  describe "#index" do
    it "works" do
      get v1_pages_path
      expect(response).to have_http_status(200)
    end

    it "works with ids parameter" do
      get v1_pages_path(ids: page.to_param)
      expect(response).to have_http_status(200)
    end

    it "works with filters" do
      offer = FactoryGirl.create :offer
      get v1_pages_path(filter: { offer_pages_offer_id_eq: offer.id })
      expect(response).to have_http_status(200)
    end
  end

  describe '#create' do
    it 'works' do
      data = {
        type: 'pages',
        attributes: FactoryGirl.attributes_for(:page)
      }
      post v1_pages_path, { data: data }, authorization: authorization
      expect(response).to be_successful
    end

    it "is forbidden without authorization" do
      data = {
        type: 'pages',
        attributes: FactoryGirl.attributes_for(:page)
      }
      post v1_pages_path, data: data
      expect(response).to be_unauthorized
    end

    it 'is unprocessable' do
      data = {
        type: 'pages',
        attributes: FactoryGirl.attributes_for(:page, slug: '')
      }
      post v1_pages_path, { data: data }, authorization: authorization
      expect(response).to be_unprocessable
    end
  end

  describe '#show' do
    it 'works' do
      get v1_page_path(id: page.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#update' do
    it 'works' do
      data = {
        type: 'pages',
        attributes: {
          title: 'Hello'
        }
      }
      patch v1_page_path(id: page.id), { data: data }, authorization: authorization
      expect(response).to be_successful
    end

    it "is forbidden without authorization" do
      data = {
        type: 'pages',
        attributes: {
          title: 'Hello'
        }
      }
      patch v1_page_path(id: page.id), data: data
      expect(response).to be_unauthorized
    end

    it 'is unprocessable' do
      data = {
        type: 'pages',
        attributes: {
          slug: ''
        }
      }
      patch v1_page_path(id: page.id), { data: data }, authorization: authorization
      expect(response).to be_unprocessable
    end
  end

  describe '#destroy' do
    it 'works' do
      delete v1_page_path(id: page.id), nil, authorization: authorization
      expect(response).to be_successful
    end

    it "is forbidden without authorization" do
      delete v1_page_path(id: page.id)
      expect(response).to be_unauthorized
    end
  end
end
