require 'rails_helper'

RSpec.describe V1::PagesController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:page) { FactoryGirl.create :page }
  let(:region) { page.region }

  before(:each) { page }

  describe '#index' do
    before(:each) { FactoryGirl.create :page }

    it 'is successful' do
      get :index
      expect(response).to be_successful
    end

    it 'filters by ids array' do
      ids = (1..3).map { FactoryGirl.create(:page).id }
      get :index, ids: ids
      expect(data.length).to eql ids.length
    end

    it 'filters by ids string' do
      ids = (1..3).map { FactoryGirl.create(:page).id }
      get :index, ids: ids.join(',')
      expect(data.length).to eql ids.length
    end
  end

  describe '#create' do
    describe 'without authentication' do
      let(:data) do
        {
          type: 'pages',
          attributes: FactoryGirl.attributes_for(:page)
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
          type: 'pages',
          attributes: FactoryGirl.attributes_for(:page)
        }
      end

      before(:each) { authenticate(user) }

      it 'is successful' do
        post :create, data: data
        expect(response).to be_successful
      end

      it 'updates the page' do
        expect {
          post :create, data: data
        }.to change(Page, :count).by 1
      end
    end

    describe 'with invalid data' do
      let(:data) do
        {
          type: 'pages',
          attributes: FactoryGirl.attributes_for(:page, slug: '')
        }
      end

      before(:each) { authenticate(user) }

      it 'is unprocessable' do
        post :create, data: data
        expect(response).to be_unprocessable
      end

      it 'is not changing the page' do
        expect {
          post :create, data: data
        }.to_not change(Page, :count)
      end
    end
  end

  describe '#show' do
    before(:each) { get :show, id: page.to_param }

    it 'is successful' do
      expect(response).to be_successful
    end
  end

  describe '#update' do
    describe 'without authentication' do
      let(:data) do
        {
          type: 'pages',
          id:   page.to_param,
          attributes: {
            title_translations: {
              de: 'hallo',
              en: 'hello'
            }
          }
        }
      end

      it 'fails' do
        patch :update, id: page.to_param, data: data
        expect(response).to be_unauthorized
      end
    end

    describe 'with valid data' do
      let(:data) do
        {
          type: 'pages',
          id:   page.to_param,
          attributes: {
            title_translations: {
              de: 'hallo',
              en: 'hello'
            }
          }
        }
      end

      before(:each) { authenticate(user) }

      it 'is successful' do
        patch :update, id: page.to_param, data: data
        expect(response).to be_successful
      end

      it 'updates the page' do
        I18n.with_locale(:en) do
          expect {
            patch :update, id: page.to_param, data: data
          }.to change { page.reload.title }.to 'hello'
        end
      end
    end

    describe 'with invalid data' do
      let(:data) do
        {
          type: 'pages',
          id:   page.to_param,
          attributes: {
            slug: ''
          }
        }
      end

      before(:each) { authenticate(user) }

      it 'is unprocessable' do
        patch :update, id: page.to_param, data: data
        expect(response).to be_unprocessable
      end

      it 'is not changing the page' do
        expect {
          patch :update, id: page.to_param, data: data
        }.to_not change { page.reload.slug }
      end
    end
  end

  describe '#destroy' do
    it 'fails without authentication' do
      delete :destroy, id: page.to_param
      expect(response).to be_unauthorized
    end

    it 'is successful' do
      authenticate(user)
      delete :destroy, id: page.to_param
      expect(response).to be_successful
    end

    it 'deletes the page' do
      authenticate(user)
      expect {
        delete :destroy, id: page.to_param
      }.to change(Page, :count).by -1
    end
  end
end
