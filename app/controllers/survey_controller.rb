class SurveyController < ApplicationController
  before_action :authenticate_user!, except: [ :home ]

  PREFERENCE_LABELS = {
    5 => "大好き",
    4 => "まあ好き",
    3 => "どちらでもない",
    2 => "あまり好きではない",
    1 => "嫌い・アレルギー"
  }.freeze

  def home
  end

  def mypage
    @answered_count = current_user.preferences.count
    @total_categories = Category.count
    @top_preferences = current_user.preferences.includes(:category).order(preference: :desc).limit(5)
    @friends_count = current_user.friends.count
    @groups_count = current_user.groups.count
    @recommended_restaurants = RecommendScore.recommend_for_user(current_user, 12)
  end

  def form
    @categories = Category.all.order(:id)
    @preferences_by_category_id = current_user.preferences.index_by(&:category_id)
  end

  def update_preferences
    (params[:preferences] || {}).each do |category_id, value|
      next if value.blank?

      preference = current_user.preferences.find_or_initialize_by(category_id: category_id)
      preference.update(preference: value)
    end

    redirect_to form_path, notice: "アンケート結果を保存しました。"
  end

  def friends
    @friends = current_user.friends.includes(:preferences)
    @incoming_requests = current_user.incoming_friend_requests
  end

  def groups
    @groups = current_user.groups.includes(:users)
    @friends = current_user.friends
  end

  def group
    @group = current_user.groups.find_by(id: params[:id])
    redirect_to groups_path, alert: "グループが見つかりませんでした。" and return if @group.nil?

    @area = params[:area]
    @budget_code = params[:budget_code]
    @budget_options = HotpepperClient::BUDGET_OPTIONS

    begin
      @recommended_restaurants = RecommendScore.recommend_restaurants_for_group(
        @group, 6, area: @area, budget_code: @budget_code
      )
    rescue HotpepperClient::ApiError => e
      flash.now[:alert] = "飲食店検索でエラーが発生しました: #{e.message}"
      @recommended_restaurants = []
    end
  end

  def search
    @keyword = params[:keyword]
    @categories = Category.order(:id)
    @selected_genre_codes = Array(params[:genre_codes]).reject(&:blank?)
    @searched = @keyword.present? || @selected_genre_codes.any?
    @no_exact_match = false

    if @searched
      begin
        @restaurants = HotpepperClient.import_and_search(keyword: @keyword.presence, genre_codes: @selected_genre_codes)
      rescue HotpepperClient::ApiError => e
        flash.now[:alert] = "飲食店検索でエラーが発生しました: #{e.message}"
        @restaurants = []
      end

      # キーワードの単語を「全部」含む店名が1件も無ければ「完全一致ではない」とみなす
      # （「吉祥寺」のような単語1つだけの一致では、完全一致とはみなさない）
      if @keyword.present? && @restaurants.any?
        keyword_terms = @keyword.split(/[\s　]+/).reject(&:blank?)
        found_exact_match = false
        @restaurants.each do |restaurant|
          all_terms_found = true
          keyword_terms.each do |term|
            hit = restaurant.name.include?(term) || restaurant.category.category.include?(term)
            all_terms_found = false unless hit
          end
          found_exact_match = true if all_terms_found
        end
        @no_exact_match = !found_exact_match
      end
    else
      @restaurants = []
    end
  end

  def restaurant
    @restaurant = Restaurant.includes(:category, :reviews).find_by(id: params[:id])
    redirect_to search_path, alert: "飲食店が見つかりませんでした。" and return if @restaurant.nil?
  end

  def visit_histories
    @visit_histories = current_user.visit_histories.includes(:restaurant).order(visited_on: :desc)
  end

  def visit_history
    @visit_history = current_user.visit_histories.includes(:restaurant).find_by(id: params[:id])
    redirect_to visit_histories_path, alert: "訪問履歴が見つかりませんでした。" and return if @visit_history.nil?

    @review = current_user.reviews.find_by(restaurant_id: @visit_history.restaurant_id)
  end
end
