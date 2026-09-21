require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:ok)
    end

    context "when signed in" do
      let(:user) { create(:user) }
      let(:team) { create(:team, name: "Platform") }
      let(:project) { create(:project, team: team, user: user, name: "Billing") }

      before do
        create(:membership, team: team, user: user, role: "owner")
        sign_in user
      end

      it "lists assigned tasks with status and priority" do
        create(:task, project: project, user: user, title: "Fix invoice rounding", status: "in_progress", priority: "urgent")
        get root_path
        expect(response.body).to include("Fix invoice rounding", "Billing", "In progress", "Urgent priority", "Platform")
      end

      it "renders tasks whose status and priority are nil" do
        create(:task, project: project, user: user, title: "Legacy row").update_columns(status: nil, priority: nil)
        get root_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Legacy row")
      end

      it "shows empty states when there is nothing yet" do
        other = create(:user)
        sign_in other
        get root_path
        expect(response.body).to include("No tasks are assigned to you yet", "Create your first team")
      end
    end
  end
end
