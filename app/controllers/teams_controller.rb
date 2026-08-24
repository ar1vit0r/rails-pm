class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show edit update destroy]
  before_action :require_member, only: %i[show]

  def index
    @teams = current_user.teams
  end

  def show
    @projects = @team.projects.includes(:user)
    @members = @team.users
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      @team.memberships.create(user: current_user, role: "owner")
      redirect_to @team, notice: "Team created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    redirect_to @team, alert: "Not authorized" unless owner_or_admin?
  end

  def update
    if owner_or_admin? && @team.update(team_params)
      redirect_to @team, notice: "Team updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if owner_or_admin?
      @team.destroy
      redirect_to teams_path, notice: "Team deleted!"
    else
      redirect_to @team, alert: "Not authorized"
    end
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, :description)
  end

  def require_member
    redirect_to teams_path, alert: "Not authorized" unless current_user.member_of?(@team)
  end

  def owner_or_admin?
    current_user.role_on(@team)&.in?(%w[owner admin])
  end
end
