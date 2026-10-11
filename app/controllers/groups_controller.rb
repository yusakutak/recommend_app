class GroupsController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.new(group_params)

    if @group.save
      @group.users << current_user

      member_ids = Array(params[:member_ids]).reject(&:blank?)
      member_ids.each do |id|
        friend = current_user.friends.find_by(id: id)
        next if friend.nil?
        next if @group.users.include?(friend)

        @group.users << friend
      end

      redirect_to group_path(@group), notice: "グループを作成しました。"
    else
      redirect_to groups_path, alert: @group.errors.full_messages.join("、")
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :description)
  end
end
