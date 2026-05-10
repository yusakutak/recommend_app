class Restaurant < ApplicationRecord
  has_many :reviews
  has_many :visit_histories
  has_many :reviewers, through: :reviews, source: :user
end
