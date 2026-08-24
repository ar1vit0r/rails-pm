require "rails_helper"

RSpec.describe "Tasks", type: :request do
  let(:user) { create(:user) }
  let(:team) { create(:team) }
  let(:project) { team.projects.create!(name: "Test", description: "Test", status: "planning", user: user) }

  before do
    team.memberships.create!(user: user, role: "owner")
    sign_in user
  end

  describe "GET /tasks/:id" do
    it "returns http success" do
      task = create(:task, project: project, user: user)
      get task_path(task)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /projects/:project_id/tasks" do
    it "creates a task" do
      expect {
        post project_tasks_path(project), params: { task: { title: "New task", status: "todo", priority: "medium" } }
      }.to change(Task, :count).by(1)
      expect(response).to redirect_to(task_path(Task.last))
    end
  end
end
