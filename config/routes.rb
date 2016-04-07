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
  get 'journeys/new', to: 'journeys#new'
  post 'journeys', to: 'journeys#create'

  scope "journeys/:start_time/" do
    resources :journeys, path: "", param: "car_plate", except: [:index, :new, :create]
  end

  resources :cars, param: "car_plate", except: [:show]
end
