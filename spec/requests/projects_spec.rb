require "rails_helper"

RSpec.describe "Projects", type: :request do
  let(:user) { create(:user) }
  let(:team) { create(:team) }

  before do
    team.memberships.create!(user: user, role: "owner")
    sign_in user
  end

  describe "POST /teams/:team_id/projects" do
    it "creates a project" do
      expect {
        post team_projects_path(team), params: { project: { name: "Test Project", description: "A test project", status: "planning" } }
      }.to change(Project, :count).by(1)
      expect(response).to redirect_to(project_path(Project.last))
    end
  end
end
