require "rails_helper"

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:team) { create(:team) }
  let(:project) { create(:project, team: team, user: user) }
  let(:task) { create(:task, project: project, user: user) }

  describe "POST /tasks/:task_id/comments" do
    it "lets a team member comment" do
      team.memberships.create!(user: user, role: "member")
      sign_in user
      expect {
        post task_comments_path(task), params: { comment: { body: "Looks good" } }
      }.to change(task.comments, :count).by(1)
      expect(response).to redirect_to(task_path(task))
    end

    it "blocks non-members" do
      sign_in create(:user)
      expect {
        post task_comments_path(task), params: { comment: { body: "Let me in" } }
      }.not_to change(Comment, :count)
      expect(response).to redirect_to(root_path)
    end
  end
end
