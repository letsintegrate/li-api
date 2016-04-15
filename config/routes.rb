Rails.application.routes.draw do
  namespace :v1 do
    resources :appointments do
      patch :confirm, on: :member, as: :confirm
      put   :confirm, on: :member
    end
    resources :email_reports, only: %i(create)
    resources :locations
    resources :offers do
      patch :confirm, on: :member, as: :confirm
      put   :confirm, on: :member
    end
    resources :offer_times
  end
end
