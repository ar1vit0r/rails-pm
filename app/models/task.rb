class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  # validate: turns a bogus value into a validation error instead of an ArgumentError on assignment.
  # allow_nil: the presence validations above already report blanks.
  enum :status, { todo: "todo", in_progress: "in_progress", done: "done" }, default: "todo", validate: { allow_nil: true }
  enum :priority, { low: 0, medium: 1, high: 2, urgent: 3 }, default: "medium", validate: { allow_nil: true }
end
