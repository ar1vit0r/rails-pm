class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @task = Task.find(params[:task_id])
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.html { redirect_to @task }
        format.turbo_stream
      end
    else
      redirect_to @task, alert: "Comment could not be saved."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
