class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def index
    @groups = current_user.groups
  end

  def show
    @messages = @group.messages.includes(:user).order(:created_at)
    @message = Message.new
    @members = @group.users
  end

  def new
    @group = Group.new
    @friends = current_user.friends
  end

  def create
    @group = Group.new(group_params)
    @group.creator = current_user
    if @group.save
      GroupMember.create(group: @group, user: current_user, role: "owner")
      if params[:friend_ids].present?
        params[:friend_ids].each do |friend_id|
          GroupMember.create(group: @group, user_id: friend_id, role: "member")
        end
      end
      redirect_to @group, notice: "グループを作成しました"
    else
      render :new
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, notice: "グループを削除しました"
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
