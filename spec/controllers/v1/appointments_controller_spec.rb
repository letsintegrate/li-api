require 'rails_helper'

RSpec.describe V1::AppointmentsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:offer) { FactoryGirl.create :offer }
  let(:offer_time) { offer.offer_times.first }
  let(:location) { offer.locations.first }
  let(:appointment) { FactoryGirl.create :appointment, :confirmed }

  before(:each) { appointment }

  describe '#index' do
    before(:each) { FactoryGirl.create :appointment }

    describe 'without authentication' do
      it 'fails' do
        get :index
        expect(response).to be_unauthorized
      end
    end

    describe 'with authentication' do
      before(:each) { authenticate(user) }

      it 'is successful' do
        get :index
        expect(response).to be_successful
      end

      it 'filters by ids array' do
        ids = (1..3).map { FactoryGirl.create(:appointment).id }
        get :index, ids: ids
        expect(data.length).to eql ids.length
      end

      it 'filters by ids string' do
        ids = (1..3).map { FactoryGirl.create(:appointment).id }
        get :index, ids: ids.join(',')
        expect(data.length).to eql ids.length
      end

      it 'filters the result' do
        appointment = FactoryGirl.create :appointment
        get :index, filter: { offer_id_eq: appointment.offer.id }
        expect(data.length).to eql(1)
      end

      it 'invludes invalid appointments' do
        appointment = FactoryGirl.create :appointment
        get :index
        appointments = assigns(:appointments)
        expect(appointments).to include appointment
      end

      context 'filtering' do
        describe '#valid' do
          it 'includes valid appointments' do
            appointment = FactoryGirl.create :appointment, :confirmed
            get :index, filter: { valid: true }
            appointments = assigns(:appointments)
            expect(appointments).to include appointment
          end

          it 'excludes invalid appointments' do
            appointment = FactoryGirl.create :appointment
            get :index, filter: { valid: true }
            appointments = assigns(:appointments)
            expect(appointments).to_not include appointment
          end
        end
      end
    end
  end

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

  describe '#destroy' do
    describe 'without authentication' do
      it 'fails' do
        delete :destroy, id: appointment.to_param
        expect(response).to be_unauthorized
      end
    end

    describe 'with authentication' do
      before(:each) { authenticate(user) }

      it 'is successful' do
        delete :destroy, id: appointment.to_param
        expect(response).to be_successful
      end

      it 'changes the appointment to be canceled' do
        expect {
          delete :destroy, id: appointment.to_param
        }.to change { appointment.reload.canceled? }.from(false).to true
      end

      it 'sends a cancelation mail to the local' do
        expect(AppointmentMailer).to receive(:cancelation_local)
                                     .with(appointment)
                                     .and_return(AppointmentMailer.cancelation_local(appointment))
        delete :destroy, id: appointment.to_param
      end

      it 'sends a cancelation mail to the refugee' do
        expect(AppointmentMailer).to receive(:cancelation_refugee)
                                     .with(appointment)
                                     .and_return(AppointmentMailer.cancelation_refugee(appointment))
        delete :destroy, id: appointment.to_param
      end

      it 'sends two e-Mails' do
        expect {
          delete :destroy, id: appointment.to_param
        }.to change { AppointmentMailer.deliveries.count }.by(2)
      end
    end
  end
end
