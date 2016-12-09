require 'rails_helper'

RSpec.describe V1::MenuItemsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:menu_item) { FactoryGirl.create :menu_item }
  let(:page) { menu_item.page }
  let(:region) { menu_item.region }

  before(:each) { menu_item }

  describe '#index' do
    before(:each) { FactoryGirl.create :menu_item }

    it 'is successful' do
      get :index
      expect(response).to be_successful
    end

    it 'filters by ids array' do
      ids = (1..3).map { FactoryGirl.create(:menu_item).id }
      get :index, ids: ids
      expect(data.length).to eql ids.length
    end

    it 'filters by ids string' do
      ids = (1..3).map { FactoryGirl.create(:menu_item).id }
      get :index, ids: ids.join(',')
      expect(data.length).to eql ids.length
    end
  end

  describe '#create' do
    describe 'without authentication' do
      let(:data) do
        {
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
      end

      it 'fails' do
        post :create, data: data
        expect(response).to be_unauthorized
      end
    end

    describe 'with valid data' do
      let(:data) do
        {
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
      end

      before(:each) { authenticate(user) }

      it 'is successful' do
        post :create, data: data
        expect(response).to be_successful
      end

      it 'updates the menu_item' do
        expect {
          post :create, data: data
        }.to change(MenuItem, :count).by 1
      end
    end

    describe 'with invalid data' do
      let(:data) do
        {
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
      end

      before(:each) { authenticate(user) }

      it 'is unprocessable' do
        post :create, data: data
        expect(response).to be_unprocessable
      end

      it 'is not changing the menu_item' do
        expect {
          post :create, data: data
        }.to_not change(MenuItem, :count)
      end
    end
  end

  describe '#show' do
    before(:each) { get :show, id: menu_item.to_param }

    it 'is successful' do
      expect(response).to be_successful
    end
  end

  describe '#update' do
    describe 'without authentication' do
      let(:data) do
        {
          type: 'menu_items',
          id:   menu_item.to_param,
          attributes: {
            name: 'foo'
          },
          relationships: {
            page: {
              data: {
                type: 'pages',
                id: page.id
              }
            }
          }
        }
      end

      it 'fails' do
        patch :update, id: menu_item.to_param, data: data
        expect(response).to be_unauthorized
      end
    end

    describe 'with valid data' do
      let(:data) do
        {
          type: 'menu_items',
          id:   menu_item.to_param,
          attributes: {
            name: 'foo'
          },
          relationships: {
            page: {
              data: {
                type: 'pages',
                id: page.id
              }
            }
          }
        }
      end

      before(:each) { authenticate(user) }

      it 'is successful' do
        patch :update, id: menu_item.to_param, data: data
        expect(response).to be_successful
      end

      it 'updates the menu_item' do
        I18n.with_locale(:en) do
          expect {
            patch :update, id: menu_item.to_param, data: data
          }.to change { menu_item.reload.name }.to 'foo'
        end
      end
    end

    describe 'with invalid data' do
      let(:data) do
        {
          type: 'menu_items',
          id:   menu_item.to_param,
          attributes: {
            name: ''
          },
          relationships: {
            page: {
              data: {
                type: 'pages',
                id: page.id
              }
            }
          }
        }
      end

      before(:each) { authenticate(user) }

      it 'is unprocessable' do
        patch :update, id: menu_item.to_param, data: data
        expect(response).to be_unprocessable
      end

      it 'is not changing the menu_item' do
        expect {
          patch :update, id: menu_item.to_param, data: data
        }.to_not change { menu_item.reload.name }
      end
    end
  end

  describe '#destroy' do
    it 'fails without authentication' do
      delete :destroy, id: menu_item.to_param
      expect(response).to be_unauthorized
    end

    it 'is successful' do
      authenticate(user)
      delete :destroy, id: menu_item.to_param
      expect(response).to be_successful
    end

    it 'deletes the menu_item' do
      authenticate(user)
      expect {
        delete :destroy, id: menu_item.to_param
      }.to change(MenuItem, :count).by -1
    end
  end
end
