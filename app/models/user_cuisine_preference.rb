class UserPreference < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  validates :score, inclusion: { in: 0..10 }
end
