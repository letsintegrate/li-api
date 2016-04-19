require 'rails_helper'

RSpec.describe "Offer items", type: :request do
  let(:offer) { FactoryGirl.create :offer, :confirmed, :upcoming }

  before(:each) { offer }

  describe "#index" do
    it "works" do
      get v1_offer_items_path
      expect(response).to have_http_status(200)
    end

    it "works with filters" do
      offer = FactoryGirl.create :offer, :confirmed, :upcoming
      get v1_offer_items_path(filter: { location_id_eq: offer.locations.first.id })
      expect(response).to have_http_status(200)
    end
  end
end
