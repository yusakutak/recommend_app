Rails.application.routes.draw do
  get "users/show"
  devise_for :users, controllers: {
  # ログイン・ログアウト
    sessions: 'users/sessions',             
  # 新規登録・ユーザー編集
    registrations: 'users/registrations',
    
    confirmations: 'users/confirmations'
  }

  resources :users, only: [:show]

  get "/form", to: "survey#form"
  get "/friends", to: "survey#friends"
  get "/groups", to: "survey#groups"
  get "/search", to: "survey#search"
  root "survey#home"
end
