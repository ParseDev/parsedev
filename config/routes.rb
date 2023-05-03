Rails.application.routes.draw do
  resources :prompts, only: [:show, :create]
  resources :datasources, only: [:index, :show, :new, :create, :destroy]
  resources :chats, only: [:new]
  resources :dataqueries, only: [:index, :create, :show, :destroy]
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'chats#new'
  
end
