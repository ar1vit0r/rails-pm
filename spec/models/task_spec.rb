require "rails_helper"

RSpec.describe Task, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:priority) }
  end

  describe "defaults" do
    it "starts as a medium priority todo" do
      task = described_class.new
      expect([ task.status, task.priority ]).to eq(%w[todo medium])
    end

    it "flags an unknown priority as invalid instead of raising" do
      task = build(:task, priority: "extreme")
      expect(task).not_to be_valid
      expect(task.errors[:priority]).to be_present
    end
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:task)).to be_valid
    end
  end
end
