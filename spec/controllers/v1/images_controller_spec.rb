require 'rails_helper'

RSpec.describe V1::ImagesController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:image) { FactoryGirl.create :image }
  let(:region) { image.region }

  before(:each) { image }

  describe '#index' do
    before(:each) { FactoryGirl.create :image }

    it 'is successful' do
      get :index
      expect(response).to be_successful
    end

    it 'filters by ids array' do
      ids = (1..3).map { FactoryGirl.create(:image).id }
      get :index, ids: ids
      expect(data.length).to eql ids.length
    end

    it 'filters by ids string' do
      ids = (1..3).map { FactoryGirl.create(:image).id }
      get :index, ids: ids.join(',')
      expect(data.length).to eql ids.length
    end
  end

  describe '#create' do
    describe 'without authentication' do
      let(:data) do
        {
          type: 'images',
          attributes: FactoryGirl.attributes_for(:image)
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
          type: 'images',
          attributes: FactoryGirl.attributes_for(:image)
        }
      end

      before(:each) { authenticate(user) }

      it 'is successful' do
        post :create, data: data
        expect(response).to be_successful
      end

      it 'updates the image' do
        expect {
          post :create, data: data
        }.to change(Image, :count).by 1
      end
    end

    describe 'with invalid data' do
      let(:data) do
        {
          type: 'images',
          attributes: FactoryGirl.attributes_for(:image, file: nil)
        }
      end

      before(:each) { authenticate(user) }

      it 'is unprocessable' do
        post :create, data: data
        expect(response).to be_unprocessable
      end

      it 'is not changing the image' do
        expect {
          post :create, data: data
        }.to_not change(Image, :count)
      end
    end
  end

  describe '#show' do
    before(:each) { get :show, id: image.to_param }

    it 'is successful' do
      expect(response).to be_successful
    end
  end

  describe '#destroy' do
    it 'fails without authentication' do
      delete :destroy, id: image.to_param
      expect(response).to be_unauthorized
    end

    it 'is successful' do
      authenticate(user)
      delete :destroy, id: image.to_param
      expect(response).to be_successful
    end

    it 'deletes the image' do
      authenticate(user)
      expect {
        delete :destroy, id: image.to_param
      }.to change(Image, :count).by -1
    end
  end
end
