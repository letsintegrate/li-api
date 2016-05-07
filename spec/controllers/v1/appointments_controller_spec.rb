require 'rails_helper'

RSpec.describe V1::AppointmentsController, type: :controller do
  let(:offer) { FactoryGirl.create :offer }
  let(:offer_time) { offer.offer_times.first }
  let(:location) { offer.locations.first }
  let(:appointment) { FactoryGirl.create :appointment, :confirmed }

  before(:each) { appointment }

  describe '#create' do
    describe 'with valid data' do
      let(:data) do
        {
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
      end

      it 'is successful' do
        post :create, data: data
        expect(response).to be_successful
      end

      it 'creates a new appointment' do
        expect {
          post :create, data: data
        }.to change(Appointment, :count).by 1
      end

      it 'calls AppointmentMailer#confirmation' do
        expect(AppointmentMailer).to receive(:confirmation)
          .with(Appointment)
          .and_return(AppointmentMailer.confirmation(appointment))
        post :create, data: data
      end

      it 'sends an e-Mail' do
        expect {
          post :create, data: data
        }.to change { AppointmentMailer.deliveries.count }.by(1)
      end

      it 'stores the X-Locale header at the appointment' do
        request.headers['HTTP_X_LOCALE'] = 'ar'
        post :create, data: data
        appointment = assigns(:appointment)
        expect(appointment.locale).to eql('ar')
      end
    end

    describe 'with invalid data' do
      let(:data) do
        {
          type: 'appointments',
          attributes: {
            email: ''
          }
        }
      end

      it 'is unprocessable' do
        post :create, data: data
        expect(response).to be_unprocessable
      end

      it 'is not creating a appointment' do
        expect {
          post :create, data: data
        }.to_not change(Appointment, :count)
      end
    end
  end

  describe '#confirm' do
    let(:appointment) { FactoryGirl.create :appointment }

    it 'is successful' do
      patch :confirm, id: appointment.to_param, token: appointment.confirmation_token
      expect(response).to be_successful
    end

    it 'confirms the record' do
      expect {
        patch :confirm, id: appointment.to_param, token: appointment.confirmation_token
      }.to change { appointment.reload.confirmed? }.from(false).to true
    end

    it 'fails with wrong confirmation token' do
      patch :confirm, id: appointment.to_param, token: 'foo'
      expect(response).to be_unprocessable
    end
  end
end
