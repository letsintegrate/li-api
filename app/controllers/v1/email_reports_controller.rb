module V1
  class EmailReportsController < BaseController
    def create
      ReportsMailer.email_address_records(params[:email]).deliver_now
      head :no_content
    end
  end
end
