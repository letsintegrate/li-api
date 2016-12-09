require 'rails_helper'

RSpec.describe "Widgets", type: :request do
  let(:user) { FactoryGirl.create :user }
  let(:application) { FactoryGirl.create :application }
  let(:token) { Doorkeeper::AccessToken.create application: application, resource_owner_id: user.id }
  let(:authorization) { "Bearer #{token.token}" }
  let(:widget) { FactoryGirl.create :widget }
  let(:page) { widget.page }

  before(:each) { widget }

  describe "#index" do
    it "works" do
      get v1_widgets_path
      expect(response).to have_http_status(200)
    end

    it "works with ids parameter" do
      get v1_widgets_path(ids: widget.to_param)
      expect(response).to have_http_status(200)
    end

    it "works with filters" do
      offer = FactoryGirl.create :offer
      get v1_widgets_path(filter: { offer_widgets_offer_id_eq: offer.id })
      expect(response).to have_http_status(200)
    end
  end

  describe '#show' do
    it 'works' do
      get v1_widget_path(id: widget.id)
      expect(response).to have_http_status(200)
    end
  end
end
