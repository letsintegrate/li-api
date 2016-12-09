module V1
  class PagesController < BaseController
    include Pundit
    include Concerns::ResourceController

    self.resource_scope = Page
  end
end
