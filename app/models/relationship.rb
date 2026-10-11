class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, uniqueness: { scope: :followed_id }
  validates :status, inclusion: { in: %w[pending accepted] }

  scope :pending, -> { where(status: "pending") }
  scope :accepted, -> { where(status: "accepted") }
end
