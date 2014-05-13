# == Schema Information
#
# Table name: finishes
#
#  id             :integer          not null, primary key
#  project_id     :integer          not null
#  area_id        :integer          not null
#  category_id    :integer          not null
#  name           :string(255)
#  location       :string(255)
#  model          :string(255)
#  quantity       :integer          default(1), not null
#  price_cents    :integer          default(0), not null
#  price_currency :string(255)      default("USD"), not null
#  description    :text
#  created_at     :datetime
#  updated_at     :datetime
#  selected       :boolean          default(FALSE)
#  selected_by_id :integer
#  selected_at    :datetime
#  comments_count :integer          default(0)
#

class Finish < ActiveRecord::Base
  belongs_to :area
  belongs_to :category
  belongs_to :project
  belongs_to :selected_by, class_name: User
  has_many :attachments, class_name: ProjectAttachment, dependent: :destroy
  has_many :comments, dependent: :destroy

  # monetize :price_cents

  def price=(val)
  end

  def price
  end

  validates :name, presence: true, uniqueness: { scope: :project_id },
    length: { maximum: 255 }
  validates :project, presence: true
  validates :quantity, presence: true, numericality: true
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

  def self.filter(opts = {})
    opts = Hash opts
    filter_by_area(opts[:area_id]).filter_by_category(opts[:category_id])
  end

  def self.filter_by_category(category_id)
    if category_id.present?
      where(category_id: category_id)
    else
      all
    end
  end

  def self.filter_by_area(area_id)
    if area_id.present?
      where(area_id: area_id)
    else
      all
    end
  end

  def self.selected
    where(selected: true)
  end

  def select!(user)
    self.selected    = true
    self.selected_by = user
    self.selected_at = Time.zone.now
    save!
  end

  def deselect!
    self.selected    = false
    self.selected_by = nil
    self.selected_at = nil
    save!
  end

end
