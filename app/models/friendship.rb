class Friendship < ApplicationRecord
  # ユーザーは送信者、フレンドは受信者を指す。
  # ユーザーモデルを開いて、フレンドIDのカラムを参照することで、フレンドのユーザー情報を取得できるようにする。
  belongs_to :user
  belongs_to :friend, class_name: "User", foreign_key: :friend_id
  scope :accepted, -> { where(status: "accepted") }
  scope :pending, -> { where(status: "pending") }
end
