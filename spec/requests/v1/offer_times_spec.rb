require 'rails_helper'

RSpec.describe "OfferTimes", type: :request do
  let(:offer) { FactoryGirl.create :offer }
  let(:offer_time) { offer.offer_times.first }

  before(:each) { offer_time }

  describe "#index" do
    it "works" do
      get v1_offer_times_path
      expect(response).to have_http_status(200)
    end

    it "works with ids parameter" do
      get v1_offer_times_path(ids: offer_time.to_param)
      expect(response).to have_http_status(200)
    end

    it "works with filters" do
      offer = FactoryGirl.create :offer
      get v1_offer_times_path(filter: { offer_id_eq: offer.id })
      expect(response).to have_http_status(200)
    end
  end

  describe '#show' do
    it 'works' do
      get v1_offer_time_path(id: offer_time.id)
      expect(response).to have_http_status(200)
    end
  end
end
