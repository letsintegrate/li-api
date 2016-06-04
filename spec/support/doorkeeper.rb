module DoorkeeperLogin
  def authenticate(user)
    application = FactoryGirl.create :application
    token = Doorkeeper::AccessToken.create application: application, resource_owner_id: user.id
    allow(controller).to receive(:doorkeeper_token) { token }
  end
end

RSpec.configure do |config|
  config.include DoorkeeperLogin, type: :controller
end
