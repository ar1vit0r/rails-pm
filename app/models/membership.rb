class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :team

  validates :role, presence: true, inclusion: { in: %w[owner admin member] }
end
