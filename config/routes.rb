Rails.application.routes.draw do
  # Root path
  get 'pages/index'

  root to: 'pages#index'
end
