require "rails_helper"

RSpec.describe Team, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "associations" do
    it { should have_many(:memberships).dependent(:destroy) }
    it { should have_many(:users).through(:memberships) }
    it { should have_many(:projects).dependent(:destroy) }
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:team)).to be_valid
    end
  end
end
