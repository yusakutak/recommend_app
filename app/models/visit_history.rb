class VisitHistory < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant

  validates :visited_on, presence: true
end
