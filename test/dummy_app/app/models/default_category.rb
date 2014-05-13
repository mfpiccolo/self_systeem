# == Schema Information
#
# Table name: default_categories
#
#  id              :integer          not null, primary key
#  organization_id :integer          not null
#  name            :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class DefaultCategory < ActiveRecord::Base
  belongs_to :organization

  validates :name, presence: true, uniqueness: { scope: :organization_id },
    length: { maximum: 255 }
  validates :organization, presence: true

  def last_for_organization?
    organization.categories.where("default_categories.id != ?", id).count == 0
  end
end
