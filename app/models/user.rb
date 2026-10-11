class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :preferences
  has_many :categories, through: :preferences
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :reviews, dependent: :destroy
  has_many :visit_histories, dependent: :destroy
  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships

  # フレンド = 自分発 or 相手発のRelationshipがstatus: acceptedになっている相手
  def friends
    User.where(id: active_relationships.accepted.select(:followed_id))
        .or(User.where(id: passive_relationships.accepted.select(:follower_id)))
  end

  def friend_with?(other_user)
    friends.exists?(other_user.id)
  end

  # 自分宛に届いている承認待ちのフレンド申請（Relationshipそのものを返す）
  def incoming_friend_requests
    passive_relationships.pending.includes(:follower)
  end

  def friend_request_sent_to?(other_user)
    active_relationships.pending.exists?(followed_id: other_user.id)
  end

  def preference_for(category)
    preferences.find_by(category_id: category.id)
  end
end
