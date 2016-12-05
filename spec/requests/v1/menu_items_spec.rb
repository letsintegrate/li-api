require 'rails_helper'

RSpec.describe "MenuItems", type: :request do
  let(:user) { FactoryGirl.create :user }
  let(:application) { FactoryGirl.create :application }
  let(:token) { Doorkeeper::AccessToken.create application: application, resource_owner_id: user.id }
  let(:authorization) { "Bearer #{token.token}" }
  let(:menu_item) { FactoryGirl.create :menu_item }
  let(:page) { menu_item.page }

  before(:each) { menu_item }

  describe "#index" do
    it "works" do
      get v1_menu_items_path
      expect(response).to have_http_status(200)
    end

    it "works with ids parameter" do
      get v1_menu_items_path(ids: menu_item.to_param)
      expect(response).to have_http_status(200)
    end

    it "works with filters" do
      offer = FactoryGirl.create :offer
      get v1_menu_items_path(filter: { offer_menu_items_offer_id_eq: offer.id })
      expect(response).to have_http_status(200)
    end
  end

  describe '#create' do
    it 'works' do
      data = {
        type: 'menu_items',
        attributes: FactoryGirl.attributes_for(:menu_item),
        relationships: {
          page: {
            data: {
              type: 'pages',
              id: page.id
            }
          }
        }
      }
      post v1_menu_items_path, { data: data }, authorization: authorization
      expect(response).to be_successful
    end

    it "is forbidden without authorization" do
      data = {
        type: 'menu_items',
        attributes: FactoryGirl.attributes_for(:menu_item),
        relationships: {
          page: {
            data: {
              type: 'pages',
              id: page.id
            }
          }
        }
      }
      post v1_menu_items_path, data: data
      expect(response).to be_unauthorized
    end

    it 'is unprocessable' do
      data = {
        type: 'menu_items',
        attributes: FactoryGirl.attributes_for(:menu_item, name: ''),
        relationships: {
          page: {
            data: {
              type: 'pages',
              id: page.id
            }
          }
        }
      }
      post v1_menu_items_path, { data: data }, authorization: authorization
      expect(response).to be_unprocessable
    end
  end

  describe '#show' do
    it 'works' do
      get v1_menu_item_path(id: menu_item.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#update' do
    it 'works' do
      data = {
        type: 'menu_items',
        attributes: {
          name: 'Hello'
        }
      }
      patch v1_menu_item_path(id: menu_item.id), { data: data }, authorization: authorization
      expect(response).to be_successful
    end

    it "is forbidden without authorization" do
      data = {
        type: 'menu_items',
        attributes: {
          name: 'Hello'
        }
      }
      patch v1_menu_item_path(id: menu_item.id), data: data
      expect(response).to be_unauthorized
    end

    it 'is unprocessable' do
      data = {
        type: 'menu_items',
        attributes: {
          name: ''
        }
      }
      patch v1_menu_item_path(id: menu_item.id), { data: data }, authorization: authorization
      expect(response).to be_unprocessable
    end
  end

  describe '#destroy' do
    it 'works' do
      delete v1_menu_item_path(id: menu_item.id), nil, authorization: authorization
      expect(response).to be_successful
    end

    it "is forbidden without authorization" do
      delete v1_menu_item_path(id: menu_item.id)
      expect(response).to be_unauthorized
    end
  end
end
