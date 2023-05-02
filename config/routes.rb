Rails.application.routes.draw do
  get 'chats/new'
  resources :prompts, only: [:show, :create]
  resources :datasources, only: [:index, :show, :new, :create]
  resources :chats, only: [:new]
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'home#index'
  
end
