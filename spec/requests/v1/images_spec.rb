require 'rails_helper'

RSpec.describe "Images", type: :request do
  let(:user) { FactoryGirl.create :user }
  let(:application) { FactoryGirl.create :application }
  let(:token) { Doorkeeper::AccessToken.create application: application, resource_owner_id: user.id }
  let(:authorization) { "Bearer #{token.token}" }
  let(:image) { FactoryGirl.create :image }

  before(:each) { image }

  describe "#index" do
    it "works" do
      get v1_images_path
      expect(response).to have_http_status(200)
    end

    it "works with ids parameter" do
      get v1_images_path(ids: image.to_param)
      expect(response).to have_http_status(200)
    end

    it "works with filters" do
      offer = FactoryGirl.create :offer
      get v1_images_path(filter: { offer_images_offer_id_eq: offer.id })
      expect(response).to have_http_status(200)
    end
  end

  describe '#create' do
    it 'works' do
      data = {
        type: 'images',
        attributes: FactoryGirl.attributes_for(:image)
      }
      post v1_images_path, { data: data }, authorization: authorization
      expect(response).to be_successful
    end

    it "is forbidden without authorization" do
      data = {
        type: 'images',
        attributes: FactoryGirl.attributes_for(:image)
      }
      post v1_images_path, data: data
      expect(response).to be_unauthorized
    end

    it 'is unprocessable' do
      data = {
        type: 'images',
        attributes: {
          file: nil
        }
      }
      post v1_images_path, { data: data }, authorization: authorization
      expect(response).to be_unprocessable
    end
  end

  describe '#show' do
    it 'works' do
      get v1_image_path(id: image.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#destroy' do
    it 'works' do
      delete v1_image_path(id: image.id), nil, authorization: authorization
      expect(response).to be_successful
    end

    it "is forbidden without authorization" do
      delete v1_image_path(id: image.id)
      expect(response).to be_unauthorized
    end
  end
end
