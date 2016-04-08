Rails.application.routes.draw do
  namespace :v1 do
  get 'offer_times/index'
  end

  namespace :v1 do
  get 'offer_times/show'
  end

  namespace :v1 do
    resources :locations
    resources :offers
    resources :offer_times
  end
end
