Rails.application.routes.draw do
  devise_for :users, controllers: {
    # ログイン・ログアウト
    sessions: "users/sessions",
    # 新規登録・ユーザー編集
    registrations: "users/registrations",

    confirmations: "users/confirmations"
  }

  resources :users, only: [ :show ]

  get   "/mypage", to: "survey#mypage"

  get   "/form", to: "survey#form"
  patch "/form", to: "survey#update_preferences", as: nil

  get   "/friends", to: "survey#friends"

  resources :relationships, only: [ :create, :destroy ] do
    member do
      patch :accept
    end
  end

  get    "/groups",     to: "survey#groups"
  post   "/groups",     to: "groups#create"
  get   "/groups/:id", to: "survey#group", as: :group

  get   "/search",          to: "survey#search"
  get   "/restaurants/:id", to: "survey#restaurant", as: :restaurant

  get   "/visit_histories",     to: "survey#visit_histories"
  get   "/visit_histories/:id", to: "survey#visit_history", as: :visit_history

  root "survey#home"
end
