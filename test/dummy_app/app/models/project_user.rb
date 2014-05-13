# == Schema Information
#
# Table name: project_users
#
#  id         :integer          not null, primary key
#  project_id :integer          not null
#  user_id    :integer          not null
#  role       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class ProjectUser < ActiveRecord::Base
  ROLES = %w(owner collaborator)

  belongs_to :project
  belongs_to :user

  validates :role, presence: true, inclusion: { in: ROLES }
  validates :project, presence: true
  validates :user, presence: true, uniqueness: { scope: :project }

  validate :one_owner, on: :update, unless: :org_relation?

  def destroy
    raise OnlyProjectOwner if only_owner? && !org_relation?
    super
  end

  private

  def org_relation?
    project.organizations.present?
  end

  def one_owner
    if (role != "owner" && role_was == "owner" && one_owner?)
      raise OnlyProjectOwner
    end
  end

  def only_owner?
   role == "owner" && one_owner?
  end

  def one_owner?
    project.project_users.map(&:role).reject {|r| r != "owner"}.length <= 1
  end

end
