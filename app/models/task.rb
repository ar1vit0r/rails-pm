class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user, optional: true
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  enum :status, { todo: "todo", in_progress: "in_progress", done: "done" }
  enum :priority, { low: 0, medium: 1, high: 2, urgent: 3 }
end
