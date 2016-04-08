Rails.application.routes.draw do
  namespace :v1 do
  get 'offer_times/index'
  end

  namespace :v1 do
  get 'offer_times/show'
  end

  namespace :v1 do
    resources :locations
    resources :offers do
      patch :confirm, on: :member, as: :confirm 
    end
    resources :offer_times
  end
end
