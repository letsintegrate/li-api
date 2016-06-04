class ApplicationController < ActionController::Base
  include Doorkeeper::Helpers::Controller

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def current_user
    return unless doorkeeper_token
    @current_user ||= begin
      id = doorkeeper_token.resource_owner_id
      User.find(id) if id.present?
    rescue
      nil
    end
  end
end
