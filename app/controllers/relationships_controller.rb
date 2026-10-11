class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_relationship, only: [ :accept, :destroy ]

  def create
    followed = User.find_by(email: params[:email].to_s.strip)

    if followed.nil?
      redirect_to friends_path, alert: "そのメールアドレスのユーザーが見つかりませんでした。" and return
    end

    if followed == current_user
      redirect_to friends_path, alert: "自分自身にはフレンド申請できません。" and return
    end

    reverse_request = current_user.passive_relationships.pending.find_by(follower_id: followed.id)

    if reverse_request
      reverse_request.update!(status: "accepted")
      redirect_to friends_path, notice: "#{followed.name}さんとフレンドになりました。"
    else
      current_user.active_relationships.find_or_create_by!(followed_id: followed.id) do |relationship|
        relationship.status = "pending"
      end
      redirect_to friends_path, notice: "#{followed.name}さんにフレンド申請を送りました。"
    end
  end

  def accept
    @relationship.update!(status: "accepted")
    redirect_to friends_path, notice: "フレンド申請を承認しました。"
  end

  def destroy
    @relationship.destroy
    redirect_to friends_path, notice: "フレンド関係を解除しました。"
  end

  private

  def set_relationship
    @relationship = Relationship.where(follower_id: current_user.id).or(Relationship.where(followed_id: current_user.id)).find(params[:id])
  end
end
