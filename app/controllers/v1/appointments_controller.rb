module V1
  class AppointmentsController < BaseController
    before_action :set_appointment, only: %i(show)

    def create
      @appointment = Appointment.create!(appointment_params.to_hash)
      AppointmentMailer.confirmation(@appointment).deliver_now
      render json: @appointment, serializer: AppointmentSerializer
    end

    def confirm
      @appointment = Appointment.find(params[:id])
      @appointment.confirm!(params[:token])
      AppointmentMailer.match(@appointment).deliver_now
      render json: @appointment, serializer: AppointmentSerializer
    end

    def show
      render json: @appointment, serializer: AppointmentSerializer
    end

    private

    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    def appointment_params
      whitelist = %i(appointment_times_attributes location_ids)
      permitted = %i(email offer_id offer_time_id location_id)
      parameters = deserialized_params
      parameters.permit(permitted).tap do |whitelisted|
        whitelist.each do |key|
          data = parameters[key]
          whitelisted[key] = data if data.present?
        end
      end
    end
  end
end
