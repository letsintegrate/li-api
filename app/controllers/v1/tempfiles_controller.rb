module V1
  class TempfilesController < BaseController
    def create
      @file = params[:file]
      render json: {
        content_type: @file.content_type,
        original_filename: @file.original_filename,
        path: @file.path
      }
    end
  end
end
