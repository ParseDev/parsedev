Rails.application.routes.draw do
  root "home#index"
  get "cron/dailysummary" # called using cron-job.org
  get "beta", to: "contact#new"
  post "contact", to: "contact#create"
  resources :dataviews, only: [:show, :index, :new, :create, :destroy] do
    post "create_dataquery"
    delete "destroy_dataquery"
  end
  resources :prompts, only: [:show, :create]
  resources :datasources, only: [:index, :show, :new, :create, :destroy, :edit, :update]
  resources :chats, only: [:new]
  post "dataquery/test", to: "dataqueries#test"
  resources :dataqueries, only: [:index, :create, :show, :destroy, :edit, :update, :new] do
    post "run"
    get "execute"
    get "download_csv"
  end
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :companies do
    post :invite, to: "users#invite"
    post "resend_invitation/:user_id", to: "users#resend_invitation", as: :resend_invitation
    resources :users, only: [:index, :destroy, :new]
  end
end
