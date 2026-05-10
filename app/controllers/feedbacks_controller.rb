class FeedbacksController < ApplicationController
  before_action :authenticate_user!

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = current_user.feedbacks.build(feedback_params)
    if @feedback.save
      redirect_to mypage_path, notice: "フィードバックを送信しました"
    else
      render :new
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:content)
  end
end
