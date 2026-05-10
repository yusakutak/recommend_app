class SurveyController < ApplicationController
  before_action :authenticate_user!, except: [:home]

  def home
  end

  def form
    @genres = Genre.all
    @user_preferences = {}
    if current_user
      current_user.user_preferences.each do |pref|
        @user_preferences[pref.genre_id] = pref.score
      end
    end
  end

  def update_preferences
    params[:preferences].each do |genre_id, score|
      pref = current_user.user_preferences.find_or_initialize_by(genre_id: genre_id.to_i)
      pref.score = score.to_i
      pref.save
    end
    redirect_to mypage_path, notice: "嗜好が更新されました"
  end

  def mypage
    @user = current_user
    @recent_visits = current_user.visit_histories.includes(:restaurant).order(created_at: :desc).limit(5)
    @friends = current_user.friends
  end

  def search
    @query = params[:q]
    @genre = params[:genre]
    if @query.present? || @genre.present?
      @restaurants = Restaurant.all
      @restaurants = @restaurants.where("name LIKE ?", "%#{@query}%") if @query.present?
      @restaurants = @restaurants.where(genre_name: @genre) if @genre.present?
    end
  end
end
