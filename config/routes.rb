Rails.application.routes.draw do
  devise_for :users, controllers: {
  # ログイン・ログアウト
    sessions: 'users/sessions',             
  # 新規登録・ユーザー編集
    registrations: 'users/registrations',
    
    confirmations: 'users/confirmations'
  }
  get "/form", to: "survey#form"
  root "survey#home"
end
