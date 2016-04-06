Rails.application.routes.draw do

  # Authentication routes
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Root path
  root to: 'pages#index'

  namespace :admin do
    resources :users
  end

  get 'journeys', to: 'journeys#index'

  scope "journeys/:start_time/" do
    resources :journeys, path: "", param: "car_plate", except: :index
  end
end
