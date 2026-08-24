require "rails_helper"

RSpec.describe Project, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }
  end

  describe "associations" do
    it { should belong_to(:team) }
    it { should belong_to(:user) }
    it { should have_many(:tasks).dependent(:destroy) }
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:project)).to be_valid
    end
  end
end
