class VisitHistory < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  has_one :review, dependent: :destroy
end
