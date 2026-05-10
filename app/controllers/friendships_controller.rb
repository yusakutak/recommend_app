class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    receiver = User.find(params[:receiver_id])
    if current_user == receiver
      redirect_back fallback_location: root_path, alert: "自分自身にフレンド申請はできません"
      return
    end
    friendship = Friendship.new(requester: current_user, receiver: receiver, status: "pending")
    if friendship.save
      redirect_back fallback_location: root_path, notice: "フレンド申請を送りました"
    else
      redirect_back fallback_location: root_path, alert: "申請に失敗しました"
    end
  end

  def accept
    friendship = Friendship.find(params[:id])
    if friendship.receiver == current_user
      friendship.update(status: "accepted")
      redirect_back fallback_location: root_path, notice: "フレンド申請を承認しました"
    else
      redirect_back fallback_location: root_path, alert: "権限がありません"
    end
  end

  def destroy
    friendship = Friendship.find(params[:id])
    if friendship.requester == current_user || friendship.receiver == current_user
      friendship.destroy
      redirect_back fallback_location: root_path, notice: "フレンドを削除しました"
    else
      redirect_back fallback_location: root_path, alert: "権限がありません"
    end
  end
end
