# == Schema Information
#
# Table name: organizations
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  logo        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  location    :text
#  description :text
#

class Organization < ActiveRecord::Base
  has_many :areas, class_name: DefaultArea, dependent: :destroy
  has_many :categories, class_name: DefaultCategory, dependent: :destroy
  has_many :organization_users, dependent: :destroy
  has_many :users, through: :organization_users
  has_many :project_organizations, dependent: :destroy
  has_many :projects, through: :project_organizations

  mount_uploader :logo, OrganizationLogoUploader

  validates :name, presence: true, uniqueness: true,
    length: { maximum: 255 }

  def owners
    users.where(organization_users: { role: "owner" })
  end

  def members
    users.where(organization_users: { role: "member" })
  end

  def default_area_names
    areas.pluck(:name)
  end

  def default_category_names
    categories.pluck(:name)
  end

end
