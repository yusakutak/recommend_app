class Friendship < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :receiver, class_name: "User"
  scope :accepted, -> { where(status: "accepted") }
  scope :pending, -> { where(status: "pending") }
end
