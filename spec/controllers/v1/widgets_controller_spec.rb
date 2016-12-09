require 'rails_helper'

RSpec.describe V1::WidgetsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:widget) { FactoryGirl.create :content_widget }
  let(:page) { widget.page }
  let(:region) { widget.region }

  before(:each) { widget }

  describe '#index' do
    before(:each) { FactoryGirl.create :widget }

    it 'is successful' do
      get :index
      expect(response).to be_successful
    end

    it 'filters by ids array' do
      ids = (1..3).map { FactoryGirl.create(:widget).id }
      get :index, ids: ids
      expect(data.length).to eql ids.length
    end

    it 'filters by ids string' do
      ids = (1..3).map { FactoryGirl.create(:widget).id }
      get :index, ids: ids.join(',')
      expect(data.length).to eql ids.length
    end
  end

  describe '#show' do
    before(:each) { get :show, id: widget.to_param }

    it 'is successful' do
      expect(response).to be_successful
    end
  end
end
