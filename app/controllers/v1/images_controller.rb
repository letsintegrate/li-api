module V1
  class ImagesController < BaseController
    include Pundit
    include Concerns::ResourceController

    self.resource_scope = Image
  end
end
