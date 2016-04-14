require 'rails_helper'

RSpec.describe V1::EmailReportsController, type: :controller do
  let(:email) { offer.email }
  let(:offer) { FactoryGirl.create :offer }

  before(:each) { offer }

  describe '#create' do
    it 'is successful' do
      post :create, email: email
      expect(response).to be_successful
    end

    it 'sends an email' do
      expect {
        post :create, email: email
      }.to change { ReportsMailer.deliveries.count }.by 1
    end
  end
end
