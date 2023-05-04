Rails.application.routes.draw do
  resources :prompts, only: [:show, :create]
  resources :datasources, only: [:index, :show, :new, :create, :destroy]
  resources :chats, only: [:new]
  resources :dataqueries, only: [:index, :create, :show, :destroy] do
    get 'download_csv'
  end
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'chats#new'
  resources :companies do
    post :invite, to: 'users#invite'
    resources :users, only: [:index, :destroy, :new]
  end
  
end
