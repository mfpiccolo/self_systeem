# == Schema Information
#
# Table name: deadlines
#
#  id          :integer          not null, primary key
#  area_id     :integer          not null
#  category_id :integer          not null
#  project_id  :integer          not null
#  due_date    :date             not null
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  complete    :boolean          default(FALSE)
#

class Deadline < ActiveRecord::Base
  belongs_to :area
  belongs_to :category
  belongs_to :project

  validates :area_id, presence: true
  validates :category_id, presence: true
  validates :project_id, presence: true
  validates :due_date, presence: true
  validates :area,
    inclusion: {
      in: proc { |record| record.project ? record.project.areas : [] }
    }
  validates :category,
    inclusion: {
      in: proc { |record| record.project ? record.project.categories : [] }
    }

  def finishes
    project.finishes.where(finishes: { category_id: category_id, area_id: area_id })
  end

  def selections
    finishes.selected
  end

  def status
    return :green  if selection_count > 0
    return :red    if due_date <= Date.today
    return :orange if (due_date - 1.week) < Date.today
    :yellow
  end

  def selection_count
    selections.count
  end

  def set_completion_status!
    self.complete = (status == :green)
    save!
  end

end
