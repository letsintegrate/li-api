module V1
  class AppointmentsController < BaseController
    before_action :doorkeeper_authorize!, except: %i(create confirm show)
    before_action :set_appointment, only: %i(confirm destroy show)

    def index
      @appointments = get_index(Appointment).joins(:offer_time)
      render json: @appointments, each_serializer: AppointmentSerializer
    end

    def create
      @appointment = Appointment.create!(appointment_params)
      AppointmentMailer.confirmation(@appointment).deliver_now
      render json: @appointment, serializer: AppointmentSerializer
    end

    def confirm
      verify_recaptcha!(@appointment)
      @appointment.confirm!(params[:token], ip: request.ip)
      AppointmentMailer.match(@appointment, locale).deliver_now
      AppointmentMailer.match_admin_notification(@appointment, locale).deliver_now
      render json: @appointment, serializer: AppointmentSerializer
    end

    def show
      render json: @appointment, serializer: AppointmentSerializer
    end

    def destroy
      @appointment.cancel!(@appointment.cancelation_token)
      AppointmentMailer.cancelation_local(@appointment).deliver_now
      AppointmentMailer.cancelation_refugee(@appointment).deliver_now
      head :no_content
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
      end.to_hash.merge(locale: I18n.locale)
    end
  end
end
