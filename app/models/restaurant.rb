class Restaurant < ApplicationRecord
  # cuisine_typeが1対1の関係なのはHotpepperAPIの仕様に合わせているため。
  belongs_to :cuisine_type
  has_many :reviews, dependent: :destroy
  has_many :visit_histories, dependent: :destroy
end
