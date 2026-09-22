class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task
  before_action :require_member

  def create
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

  def set_task
    @task = Task.find(params[:task_id])
  end

  def require_member
    redirect_to root_path, alert: "Not authorized" unless current_user.member_of?(@task.project.team)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
