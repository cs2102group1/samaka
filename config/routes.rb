Rails.application.routes.draw do

  # Authentication routes
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Root path
  get 'pages/index'
  root to: 'pages#index'
end
