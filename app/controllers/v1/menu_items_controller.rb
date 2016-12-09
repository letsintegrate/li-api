module V1
  class MenuItemsController < BaseController
    include Pundit
    include Concerns::ResourceController

    self.resource_scope = MenuItem
  end
end
