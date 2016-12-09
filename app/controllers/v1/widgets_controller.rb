module V1
  class WidgetsController < BaseController
    include Pundit
    include Concerns::ResourceController

    self.resource_scope = Widget
  end
end
