# == Schema Information
#
# Table name: areas
#
#  id         :integer          not null, primary key
#  project_id :integer          not null
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Area < ActiveRecord::Base
  belongs_to :project
  has_many :finishes
  has_many :deadlines

  validates :name, presence: true, uniqueness: { scope: :project_id },
    length: { maximum: 255 }
  validates :project, presence: true

  def last_for_project?
    project.areas.where("areas.id != ?", id).count == 0
  end

  def have_dependents?
    finishes.any? || deadlines.any?
  end

end
