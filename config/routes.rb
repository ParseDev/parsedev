Rails.application.routes.draw do
  resources :prompts, only: [:show, :create]
  resources :datasources, only: [:index, :show, :new, :create, :destroy, :edit, :update]
  resources :chats, only: [:new]
  resources :dataqueries, only: [:index, :create, :show, :destroy, :edit, :update] do
    post "run"
    get "download_csv"
  end
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :companies do
    post :invite, to: "users#invite"
    post "resend_invitation/:user_id", to: "users#resend_invitation", as: :resend_invitation
    resources :users, only: [:index, :destroy, :new]
  end

  root "chats#new"
end
