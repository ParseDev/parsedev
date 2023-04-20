Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :datasources, only: [:index, :show, :new, :create]
end
