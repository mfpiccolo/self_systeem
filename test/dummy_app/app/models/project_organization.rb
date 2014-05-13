# == Schema Information
#
# Table name: project_organizations
#
#  id              :integer          not null, primary key
#  project_id      :integer          not null
#  organization_id :integer          not null
#  created_at      :datetime
#  updated_at      :datetime
#

class ProjectOrganization < ActiveRecord::Base
  belongs_to :project
  belongs_to :organization

  validates :project, presence: true
  validates :organization, presence: true, uniqueness: { scope: :project }
end
