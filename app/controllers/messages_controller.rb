class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id])
    @message = @group.messages.build(message_params)
    @message.user = current_user
    if @message.save
      redirect_to @group
    else
      redirect_to @group, alert: "メッセージを送信できませんでした"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
