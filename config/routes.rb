require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
end

Rails.application.routes.draw do
  use_doorkeeper
  mount Sidekiq::Web, at: "/sidekiq"

  namespace :v1 do
    resources :appointments do
      patch :confirm, on: :member, as: :confirm
      put   :confirm, on: :member
    end
    resources :email_reports, path: 'email-reports', only: %i(create)
    resources :locations
    resources :menu_items
    resources :offers do
      patch :confirm, on: :member, as: :confirm
      put   :confirm, on: :member
    end
    resources :offer_items, path: 'offer-items'
    resources :offer_times, path: 'offer-times'
    resources :pages
    resources :regions
    resources :tempfiles, only: %i(create)
    resources :users do
      get :me, on: :collection, as: :me
    end
  end
end
