class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit update destroy]
  before_action :set_team
  before_action :require_member
  before_action :require_owner_or_admin, only: :destroy

  def show
    @tasks = @project.tasks.includes(:user).order(created_at: :desc)
    @task = Task.new
  end

  def new
    @project = @team.projects.new
  end

  def create
    @project = @team.projects.build(project_params)
    @project.user = current_user
    if @project.save
      redirect_to @project, notice: "Project created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Project updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to @team, notice: "Project deleted!"
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def set_team
    @team = @project ? @project.team : Team.find(params[:team_id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :status, :deadline)
  end

  def require_member
    redirect_to root_path, alert: "Not authorized" unless current_user.member_of?(@team)
  end

  def require_owner_or_admin
    redirect_to @project, alert: "Not authorized" unless current_user.role_on(@team)&.in?(%w[owner admin])
  end
end
