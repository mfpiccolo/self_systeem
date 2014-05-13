# == Schema Information
#
# Table name: project_attachments
#
#  id           :integer          not null, primary key
#  project_id   :integer          not null
#  file         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  finish_id    :integer
#  content_type :string(255)
#

class ProjectAttachment < ActiveRecord::Base
  belongs_to :project
  belongs_to :finish

  validates :file, presence: true
  validates :project, presence: true
  validates :finish, allow_blank: true,
    inclusion: {
      in: proc { |record| record.project ? record.project.finishes : [nil] }
    }

  def image?
    content_type.starts_with? "image"
  end

end
