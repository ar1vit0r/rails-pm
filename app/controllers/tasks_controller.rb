class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]
  before_action :set_project
  before_action :require_member

  def show
    @comment = Comment.new
    @comments = @task.comments.includes(:user).order(created_at: :asc)
  end

  def new
    @task = @project.tasks.new
  end

  def create
    @task = @project.tasks.build(task_params)
    @task.user = current_user if task_params[:user_id].blank?
    if assignee_on_team? && @task.save
      redirect_to @task, notice: "Task created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @task.assign_attributes(task_params)
    if assignee_on_team? && @task.save
      respond_to do |format|
        format.html { redirect_to @task, notice: "Task updated!" }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@task, partial: "tasks/task", locals: { task: @task }) }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    project = @task.project
    @task.destroy
    redirect_to project, notice: "Task deleted!"
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def set_project
    @project = @task ? @task.project : Project.find(params[:project_id])
  end

  def require_member
    redirect_to root_path, alert: "Not authorized" unless current_user.member_of?(@project.team)
  end

  # Only checked when the assignee changes, so editing a task never fails over a legacy assignee.
  def assignee_on_team?
    return true if @task.user.nil? || !@task.user_id_changed? || @project.team.users.exists?(@task.user_id)

    @task.errors.add(:user, "must be a member of this team")
    false
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :due_date, :user_id)
  end
end
