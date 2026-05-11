class CuisineType < ApplicationRecord
  has_many :restaurants
  has_many :user_cuisine_preferences
  has_many :users, through: :user_cuisine_preferences
end
