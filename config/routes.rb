Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    confirmations: "users/confirmations"
  }

  resources :users, only: [:show]
  resources :friendships, only: [:create, :destroy] do
    member do
      patch :accept
    end
  end
  resources :groups do
    resources :messages, only: [:create]
    resources :group_members, only: [:create, :destroy]
  end
  resources :restaurants, only: [:show] do
    resources :reviews, only: [:new, :create]
    resources :visit_histories, only: [:create]
  end
  resources :feedbacks, only: [:new, :create]

  get "/form", to: "survey#form", as: :form
  get "/mypage", to: "survey#mypage", as: :mypage
  get "/search", to: "survey#search", as: :search
  post "/survey", to: "survey#update_preferences", as: :update_preferences

  root "survey#home"
end
