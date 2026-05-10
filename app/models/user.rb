class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_preferences, dependent: :destroy
  has_many :genres, through: :user_preferences
  has_many :reviews, dependent: :destroy
  has_many :visit_histories, dependent: :destroy
  has_many :visited_restaurants, through: :visit_histories, source: :restaurant
  has_many :messages, dependent: :destroy
  has_many :group_members, dependent: :destroy
  has_many :groups, through: :group_members
  has_many :feedbacks, dependent: :destroy

  # Friendships as requester
  has_many :sent_friendships, class_name: "Friendship", foreign_key: :requester_id, dependent: :destroy
  has_many :received_friendships, class_name: "Friendship", foreign_key: :receiver_id, dependent: :destroy

  def friends
    accepted_sent = Friendship.where(requester_id: id, status: "accepted").pluck(:receiver_id)
    accepted_received = Friendship.where(receiver_id: id, status: "accepted").pluck(:requester_id)
    User.where(id: accepted_sent + accepted_received)
  end

  def friend?(other_user)
    friends.include?(other_user)
  end

  def friendship_with(other_user)
    Friendship.where(requester_id: id, receiver_id: other_user.id)
              .or(Friendship.where(requester_id: other_user.id, receiver_id: id))
              .first
  end
end
