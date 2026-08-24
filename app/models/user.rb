class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :teams, through: :memberships
  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :comments, dependent: :destroy

  def admin?
    role == "admin"
  end

  def member_of?(team)
    memberships.exists?(team: team)
  end

  def role_on(team)
    memberships.find_by(team: team)&.role
  end
end
