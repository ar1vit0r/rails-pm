class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]

  def show
    @comment = Comment.new
    @comments = @task.comments.includes(:user).order(created_at: :asc)
  end

  def new
    @project = Project.find(params[:project_id])
    @task = @project.tasks.new
  end

  def create
    @project = Project.find(params[:project_id])
    @task = @project.tasks.build(task_params)
    if @task.save
      redirect_to @task, notice: "Task created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
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

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :due_date, :user_id)
  end
end
