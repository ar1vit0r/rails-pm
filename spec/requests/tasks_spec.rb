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

  describe "GET /projects/:project_id/tasks/new" do
    it "renders the form" do
      get new_project_task_path(project)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("New task")
    end
  end

  describe "GET /tasks/:id/edit" do
    it "renders the form" do
      get edit_task_path(create(:task, project: project, user: user))
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Edit task")
    end
  end

  describe "PATCH /tasks/:id" do
    let(:task) { create(:task, project: project, user: user) }

    it "updates the task" do
      patch task_path(task), params: { task: { title: "Renamed" } }
      expect(response).to redirect_to(task_path(task))
      expect(task.reload.title).to eq("Renamed")
    end

    it "re-renders the form when the assignee is blank instead of raising" do
      patch task_path(task), params: { task: { user_id: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(task.reload.user).to eq(user)
    end

    it "does not fail over a legacy assignee who left the team" do
      legacy = create(:task, project: project, user: create(:user))
      patch task_path(legacy), params: { task: { title: "Renamed" } }
      expect(response).to redirect_to(task_path(legacy))
    end
  end

  describe "authorization" do
    let(:outsider) { create(:user) }

    before { sign_in outsider }

    it "blocks non-members from the new form" do
      get new_project_task_path(project)
      expect(response).to redirect_to(root_path)
    end

    it "blocks non-members from creating tasks" do
      expect {
        post project_tasks_path(project), params: { task: { title: "Nope", status: "todo", priority: "low" } }
      }.not_to change(Task, :count)
      expect(response).to redirect_to(root_path)
    end

    it "blocks non-members from viewing, updating and deleting a task" do
      task = create(:task, project: project, user: user)
      get task_path(task)
      expect(response).to redirect_to(root_path)
      patch task_path(task), params: { task: { title: "Hijack" } }
      expect(task.reload.title).not_to eq("Hijack")
      expect { delete task_path(task) }.not_to change(Task, :count)
    end
  end

  describe "POST /projects/:project_id/tasks" do
    it "creates a task" do
      expect {
        post project_tasks_path(project), params: { task: { title: "New task", status: "todo", priority: "medium" } }
      }.to change(Task, :count).by(1)
      expect(response).to redirect_to(task_path(Task.last))
    end

    it "assigns the creator when no assignee is given" do
      post project_tasks_path(project), params: { task: { title: "New task", status: "todo", priority: "medium" } }
      expect(Task.last.user).to eq(user)
    end

    it "keeps an explicit assignee who is on the team" do
      other = create(:user)
      team.memberships.create!(user: other, role: "member")
      post project_tasks_path(project), params: { task: { title: "New task", status: "todo", priority: "medium", user_id: other.id } }
      expect(Task.last.user).to eq(other)
    end

    it "rejects an assignee outside the team" do
      outsider = create(:user)
      expect {
        post project_tasks_path(project), params: { task: { title: "New task", status: "todo", priority: "medium", user_id: outsider.id } }
      }.not_to change(Task, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "rejects a nonexistent assignee instead of reassigning to the creator" do
      expect {
        post project_tasks_path(project), params: { task: { title: "New task", status: "todo", priority: "medium", user_id: 99_999 } }
      }.not_to change(Task, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "rejects an unknown priority with 422 instead of raising" do
      expect {
        post project_tasks_path(project), params: { task: { title: "New task", status: "todo", priority: "extreme" } }
      }.not_to change(Task, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "re-renders the form when the title is blank" do
      expect {
        post project_tasks_path(project), params: { task: { title: "", status: "todo", priority: "medium" } }
      }.not_to change(Task, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
