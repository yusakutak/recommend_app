class VisitHistoriesController < ApplicationController
  before_action :authenticate_user!

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    vh = VisitHistory.find_or_create_by(user: current_user, restaurant: @restaurant) do |v|
      v.visited_at = Time.current
    end
    redirect_to @restaurant, notice: "訪問履歴を記録しました"
  end
end
