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
    resources :requests, param: "request_datetime"
  end

  get 'journeys', to: 'journeys#index'
  get 'journeys/new', to: 'journeys#new'
  post 'journeys', to: 'journeys#create'

  post 'passengers', to: 'passengers#create'
  put 'passengers/:start_time/:car_plate/:onboard', to: 'passengers#offboard'

  scope "journeys/:start_time/" do
    resources :journeys, path: "", param: "car_plate", except: [:index, :new, :create]
  end


  resources :cars, param: "car_plate", except: [:show]
  resources :requests, only: [:new, :create]


end
