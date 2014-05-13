# == Schema Information
#
# Table name: organization_users
#
#  id              :integer          not null, primary key
#  organization_id :integer          not null
#  user_id         :integer          not null
#  role            :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class OrganizationUser < ActiveRecord::Base
  ROLES = %w(owner member)

  belongs_to :organization
  belongs_to :user

  validates :role, inclusion: { in: ROLES }
  validates :organization, presence: true
  validates :user, presence: true, uniqueness: { scope: :organization }

  validate :one_owner, on: :update

  def destroy
    raise OnlyOrganizationOwner if only_owner?
    super
  end


  private

  def one_owner
    raise OnlyOrganizationOwner if (role != "owner" && one_owner?)
  end

  def only_owner?
   role == "owner" && one_owner?
  end

  def one_owner?
    organization.organization_users.map(&:role).reject {|r| r != "owner"}.length <= 1
  end
end
