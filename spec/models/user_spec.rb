require "rails_helper"

RSpec.describe User, type: :model do
  describe "factory" do
    it "has a valid factory" do
      expect(build(:user)).to be_valid
    end

    it "has a valid admin factory" do
      expect(build(:user, :admin)).to be_valid
    end
  end

  describe "#admin?" do
    it "returns true for admin users" do
      expect(build(:user, :admin).admin?).to be true
    end

    it "returns false for regular users" do
      expect(build(:user).admin?).to be false
    end
  end

  describe "#member_of?" do
    it "returns true when user is member of team" do
      user = create(:user)
      team = create(:team)
      create(:membership, user: user, team: team)
      expect(user.member_of?(team)).to be true
    end

    it "returns false when user is not member" do
      user = create(:user)
      team = create(:team)
      expect(user.member_of?(team)).to be false
    end
  end
end
