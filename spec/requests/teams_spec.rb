require "rails_helper"

RSpec.describe "Teams", type: :request do
  let(:user) { create(:user) }

  describe "GET /teams" do
    context "when logged in" do
      before { sign_in user }

      it "returns http success" do
        get teams_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        get teams_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /teams" do
    context "when logged in" do
      before { sign_in user }

      it "creates a team" do
        expect {
          post teams_path, params: { team: { name: "Test Team", description: "A test team" } }
        }.to change(Team, :count).by(1)
        expect(response).to redirect_to(team_path(Team.last))
      end
    end
  end
end
