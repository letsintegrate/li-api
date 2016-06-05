require 'rails_helper'

RSpec.describe "Appointments", type: :request do
  let(:offer) { FactoryGirl.create :offer }
  let(:offer_time) { offer.offer_times.first }
  let(:location) { offer.locations.first }
  let(:appointment) { FactoryGirl.create :appointment, :confirmed }

  let(:user) { FactoryGirl.create :user }
  let(:application) { FactoryGirl.create :application }
  let(:token) { Doorkeeper::AccessToken.create application: application, resource_owner_id: user.id }
  let(:authorization) { "Bearer #{token.token}" }

  before(:each) { appointment }


  describe "#index" do
    it "works" do
      get v1_appointments_path, nil, authorization: authorization
      expect(response).to have_http_status(200)
    end

    it "is forbidden without authorization" do
      get v1_appointments_path
      expect(response).to be_unauthorized
    end

    it "works with ids parameter" do
      get v1_appointments_path(ids: appointment.to_param), nil, authorization: authorization
      expect(response).to have_http_status(200)
    end

    it "works with filters" do
      user = FactoryGirl.create :user
      get v1_appointments_path(filter: { id_eq: appointment.id }), nil, authorization: authorization
      expect(response).to have_http_status(200)
    end
  end

  describe '#create' do
    it 'works' do
      data = {
        type: 'appointments',
        attributes: {
          email: FFaker::Internet.email
        },
        relationships: {
          offer: {
            data: {
              type: 'offers',
              id: offer.id
            }
          },
          location: {
            data: {
              type: 'locations',
              id: location.id
            }
          },
          offer_time: {
            data: {
              type: 'offer-times',
              id: offer_time.id
            }
          }
        }
      }
      post v1_appointments_path, data: data
      expect(response).to be_successful
    end

    it 'is unprocessable' do
      data = {
        type: 'appointments',
        attributes: {
          email: ''
        }
      }
      post v1_appointments_path, data: data
      expect(response).to be_unprocessable
    end
  end

  describe '#confirm' do
    it 'works' do
      patch confirm_v1_appointment_path(id: appointment.id, token: appointment.confirmation_token)
      expect(response).to have_http_status(200)
    end

    it 'fails with invalid token' do
      patch confirm_v1_appointment_path(id: appointment.id, token: 'foo')
      expect(response).to be_unprocessable
    end
  end
end
