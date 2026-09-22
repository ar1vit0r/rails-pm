require "rails_helper"

RSpec.describe "Projects", type: :request do
  let(:user) { create(:user) }
  let(:team) { create(:team) }
  let(:project) { create(:project, team: team, user: user, name: "Billing") }

  before do
    team.memberships.create!(user: user, role: "owner")
    sign_in user
  end

  describe "GET /projects/:id" do
    it "returns http success" do
      get project_path(project)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /teams/:team_id/projects/new" do
    it "renders the form" do
      get new_team_project_path(team)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("New project")
    end
  end

  describe "POST /teams/:team_id/projects" do
    it "creates a project" do
      expect {
        post team_projects_path(team), params: { project: { name: "Test Project", description: "A test project", status: "planning" } }
      }.to change(Project, :count).by(1)
      expect(response).to redirect_to(project_path(Project.last))
    end

    it "re-renders the form when the name is blank" do
      expect {
        post team_projects_path(team), params: { project: { name: "", status: "planning" } }
      }.not_to change(Project, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "re-renders the form when the status is not a valid value" do
      expect {
        post team_projects_path(team), params: { project: { name: "X", status: "bogus" } }
      }.not_to change(Project, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /projects/:id/edit" do
    it "renders the form" do
      get edit_project_path(project)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Edit project")
    end
  end

  describe "PATCH /projects/:id" do
    it "updates the project" do
      patch project_path(project), params: { project: { name: "Renamed" } }
      expect(response).to redirect_to(project_path(project))
      expect(project.reload.name).to eq("Renamed")
    end

    it "re-renders the form when the name is blank" do
      patch project_path(project), params: { project: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(project.reload.name).to eq("Billing")
    end
  end

  describe "DELETE /projects/:id" do
    it "lets a team owner delete the project" do
      project
      expect { delete project_path(project) }.to change(Project, :count).by(-1)
      expect(response).to redirect_to(team_path(team))
    end

    it "keeps the project when a plain member tries to delete it" do
      member = create(:user)
      team.memberships.create!(user: member, role: "member")
      sign_in member
      project
      expect { delete project_path(project) }.not_to change(Project, :count)
      expect(response).to redirect_to(project_path(project))
    end
  end

  describe "authorization" do
    before { sign_in create(:user) }

    it "blocks non-members from every action" do
      project
      get project_path(project)
      expect(response).to redirect_to(root_path)
      get new_team_project_path(team)
      expect(response).to redirect_to(root_path)
      get edit_project_path(project)
      expect(response).to redirect_to(root_path)
      patch project_path(project), params: { project: { name: "Hijack" } }
      expect(project.reload.name).to eq("Billing")
      expect { delete project_path(project) }.not_to change(Project, :count)
    end

    it "blocks non-members from creating projects" do
      expect {
        post team_projects_path(team), params: { project: { name: "Nope", status: "planning" } }
      }.not_to change(Project, :count)
      expect(response).to redirect_to(root_path)
    end
  end
end
