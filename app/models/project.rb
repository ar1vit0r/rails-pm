class Project < ApplicationRecord
  belongs_to :team
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :status, presence: true

  # validate: turns a bogus value into a validation error instead of an ArgumentError on assignment.
  # allow_nil: the presence validation above already reports blanks.
  enum :status, { planning: "planning", in_progress: "in_progress", completed: "completed" }, validate: { allow_nil: true }
end
