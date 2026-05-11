class Group < ApplicationRecord
  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members
  has_many :messages, dependent: :destroy
end
