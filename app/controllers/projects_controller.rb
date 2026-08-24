class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit update destroy]

  def show
    @tasks = @project.tasks.includes(:user).order(created_at: :desc)
    @task = Task.new
  end

  def new
    @team = Team.find(params[:team_id])
    @project = @team.projects.new
  end

  def create
    @team = Team.find(params[:team_id])
    @project = @team.projects.build(project_params)
    @project.user = current_user
    if @project.save
      redirect_to @project, notice: "Project created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @team = @project.team
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Project updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    team = @project.team
    @project.destroy
    redirect_to team, notice: "Project deleted!"
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :status, :deadline)
  end
end
