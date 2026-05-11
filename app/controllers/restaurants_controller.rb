class RestaurantsController < ApplicationController
  before_action :authenticate_user!
  def index
    @restaurants = []  # 後でホットペッパーAPI繋ぐ
  end
  def show
    @restaurant = Restaurant.find(params[:id])
    @reviews = @restaurant.reviews.includes(:user).order(created_at: :desc)
    @user_review = @restaurant.reviews.find_by(user: current_user)
  end
end
