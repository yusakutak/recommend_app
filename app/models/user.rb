class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  

  has_many :preferences
  has_many :categories, through: :preferences
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "user_id",
                                  dependent:   :destroy
end
