class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.build(review_params)
    @review.user = current_user
    if @review.save
      VisitHistory.find_or_create_by(user: current_user, restaurant: @restaurant) do |vh|
        vh.visited_at = Time.current
      end
      redirect_to @restaurant, notice: "レビューを投稿しました"
    else
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
