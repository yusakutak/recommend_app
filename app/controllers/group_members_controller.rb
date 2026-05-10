class GroupMembersController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id])
    user = User.find(params[:user_id])
    GroupMember.find_or_create_by(group: @group, user: user)
    redirect_to @group, notice: "メンバーを追加しました"
  end

  def destroy
    @group = Group.find(params[:group_id])
    member = GroupMember.find(params[:id])
    member.destroy
    redirect_to @group, notice: "メンバーを削除しました"
  end
end
