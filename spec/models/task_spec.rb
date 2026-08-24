require "rails_helper"

RSpec.describe Task, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:priority) }
  end

  describe "associations" do
    it { should belong_to(:project) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:task)).to be_valid
    end
  end
end
