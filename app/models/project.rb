class Project < ApplicationRecord
  belongs_to :team
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :status, presence: true

  enum :status, { planning: "planning", in_progress: "in_progress", completed: "completed" }
end
