Rails.application.routes.draw do
  resources :prompts, only: [:show, :create]
  devise_for :users
  root 'home#index'
  resources :datasources, only: [:index, :show, :new, :create]
end
