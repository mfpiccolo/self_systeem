# == Schema Information
#
# Table name: budget_items
#
#  id              :integer          not null, primary key
#  category_id     :integer          not null
#  project_id      :integer          not null
#  amount_cents    :integer          default(0), not null
#  amount_currency :string(255)      default("USD"), not null
#  created_at      :datetime
#  updated_at      :datetime
#  area_id         :integer          not null
#

class BudgetItem < ActiveRecord::Base
  belongs_to :area
  belongs_to :category
  belongs_to :project

  monetize :amount_cents

  validates :project_id, presence: true
  validates :area_id, presence: true
  validates :category_id, presence: true
  validates :area,
    inclusion: {
      in: proc { |record| record.project ? record.project.areas : [] }
    }
  validates :category,
    inclusion: {
      in: proc { |record| record.project ? record.project.categories : [] }
    }

  def self.filter_by_category(category_id)
    if category_id.present?
      where(category_id: category_id)
    else
      all
    end
  end

  def finishes
    project.finishes.where(area_id: area_id).where(category_id: category_id)
  end

end
