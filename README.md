# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

-deviseの説明-
Depending on your application's configuration some manual setup may be required:        

  1. Ensure you have defined default url options in your environments files. Here       
     is an example of default_url_options appropriate for a development environment     
     in config/environments/development.rb:

       config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }     

     In production, :host should be set to the actual host of your application.

     * Required for all applications. *

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root to: "home#index"

     * Not required for API-only Applications *

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

     * Not required for API-only Applications *

  4. You can copy Devise views (for customization) to your app by running:

       rails g devise:views

     * Not required *
# Todoリスト
① ER図を完成させる
② モデルの関連をRailsコードで書いてみる
③ migrationをまとめて作成する
④ ワイヤーフレームを作る
⑤ route設計
⑥ Devise導入（認証）
⑦ 主要CRUDを作って動かす

# 内容
概要
現代社会において、友人やグループでの飲食店選定は、個人の嗜好の多様性や情報過多により、しばしば非効率的なプロセスとなっている。本研究で提案する「今日の食事決め太郎」は、この課題を解決するためのパーソナライズされたソーシャル型飲食店推薦ウェブアプリケーションである。
本システムは、ユーザのレビューフィードバックに基づく学習型レコメンドエンジンを中核とし、料理ジャンル、予算、移動距離、雰囲気といった嗜好パラメータを動的に更新・可視化する。さらに、フレンドの嗜好パラメータ相互閲覧機能や、候補店舗を共有できるグループチャット機能といったソーシャル要素を統合することで、集団意思決定プロセスを支援する。
これにより、利用者は個人の好みに最適化されたレコメンドを受け取るとともに、他者の好みを考慮した効率的かつ合意形成が容易な食事場所決定を実現する。本アプリケーションは、従来の検索ベースのプラットフォームに対し、パーソナライゼーションとソーシャルコラボレーションの側面で優位性を示す。

機能
・ユーザ登録並びにdeviseを用いた認証機能(名前・ID・Email登録)
・ログイン/ログアウト機能
・フレンド登録/削除機能
・飲食店検索機能(飲食店はHotpepperAPIを利用)
・グループ作成/参加機能(フレンドをグループへ招待、グループへ参加可能)
・グループ内チャット機能(LINEのようなトークルームをイメージ)
・レコメンドによって訪れた飲食店に対するレビュー機能
・食事/属性嗜好アンケート機能(食事の好き嫌いの5段階評価＋
飲食店の価格帯・サービス内容の好みのチェックボックス形式のアンケート)
・訪れた飲食店の履歴確認機能(過去に自分やフレンドがその店につけた評価の確認やお店の概要、位置をマップ上で確認可能)
・マイページ上での個人向け飲食店推薦機能(アンケート機能によるユーザ地震に対する飲食店の表示)
・フィードバック機能(ユーザが本アプリを利用した際の意見を入力する機能)
・各ユーザの嗜好パラメータ確認機能(アンケート機能の嗜好情報がベース)
・レビュー後のユーザ嗜好情報の自動調整

```mermaid
erDiagram
    USERS ||--o{ REVIEWS : &quot;投稿&quot;
    USERS ||--o| PREFERENCE_PARAMETERS : &quot;学習値&quot;
    USERS ||--o{ VISIT_HISTORIES : &quot;履歴&quot;
    RESTAURANTS ||--o{ REVIEWS : &quot;評価&quot;
    RESTAURANTS ||--o{ VISIT_HISTORIES : &quot;訪問&quot;

    USERS {
        bigint id PK
        string nickname
        string email
    }
    RESTAURANTS {
        bigint id PK
        string name
        string category
    }
    REVIEWS {
        bigint id PK
        bigint user_id FK
        bigint restaurant_id FK
        integer rating
    }
    PREFERENCE_PARAMETERS {
        bigint id PK
        bigint user_id FK
        jsonb cuisine_preferences
    }
    VISIT_HISTORIES {
        bigint id PK
        bigint user_id FK
        bigint restaurant_id FK
    }
```