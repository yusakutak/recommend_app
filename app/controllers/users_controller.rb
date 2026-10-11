class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])

    unless @user == current_user || current_user.friend_with?(@user)
      redirect_to friends_path, alert: "フレンドの嗜好パラメータのみ閲覧できます。" and return
    end

    @preferences = @user.preferences.includes(:category).order(preference: :desc)
  end
end
