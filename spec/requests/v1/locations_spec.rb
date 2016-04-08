require 'rails_helper'

RSpec.describe "Locations", type: :request do
  let(:location) { FactoryGirl.create :location }

  before(:each) { location }

  describe "#index" do
    it "works" do
      get v1_locations_path
      expect(response).to have_http_status(200)
    end

    it "works with ids parameter" do
      get v1_locations_path(ids: location.to_param)
      expect(response).to have_http_status(200)
    end

    it "works with filters" do
      offer = FactoryGirl.create :offer
      get v1_locations_path(filter: { offer_locations_offer_id_eq: offer.id })
      expect(response).to have_http_status(200)
    end
  end

  describe '#show' do
    it 'works' do
      get v1_location_path(id: location.id)
      expect(response).to have_http_status(200)
    end
  end
end
