Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    confirmations: "users/confirmations"
  }

  root "pages#mypage"

  # ユーザー
  resources :users, only: [ :show ]

  # フレンド
  resources :friendships, only: [ :index, :create, :destroy ] do
    member do
      patch :accept
    end
  end

  # グループ
  resources :groups, only: [ :index, :show, :new, :create ] do
    resources :messages,      only: [ :create ]
    resources :group_members, only: [ :index, :create, :destroy ]
  end

  # 飲食店・レビュー
  resources :restaurants, only: [ :index, :show ] do
    resources :reviews,         only: [ :new, :create, :index ]
  end

  # 訪問履歴
  resources :visit_histories, only: [ :index, :show ]

  # 嗜好アンケート
  get  "/form",   to: "user_cuisine_preferences#edit",   as: :form
  post "/survey", to: "user_cuisine_preferences#update", as: :survey

  # マイページ
  get "/mypage", to: "pages#mypage", as: :mypage
end
