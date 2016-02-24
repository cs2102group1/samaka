Rails.application.routes.draw do

  # Authentication routes
  devise_for :users

  # Root path
  get 'pages/index'
  root to: 'pages#index'
end
