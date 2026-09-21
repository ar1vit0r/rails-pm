class PagesController < ApplicationController
  def home
    if user_signed_in?
      @teams = current_user.teams.includes(:projects, :users)
      @recent_tasks = current_user.tasks.includes(:project).order(updated_at: :desc).limit(5)
    end
  end
end
