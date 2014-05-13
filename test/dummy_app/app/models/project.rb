# == Schema Information
#
# Table name: projects
#
#  id                             :integer          not null, primary key
#  name                           :string(255)
#  description                    :text
#  created_at                     :datetime
#  updated_at                     :datetime
#  location                       :text
#  total_budget_cents             :integer          default(0)
#  total_budget_currency          :string(255)      default("USD"), not null
#  selected_total_amount_cents    :integer          default(0), not null
#  selected_total_amount_currency :string(255)      default("USD"), not null
#  deadline_notification_sent_at  :datetime
#

class Project < ActiveRecord::Base
  has_many :areas, dependent: :destroy
  has_many :attachments, class_name: ProjectAttachment, dependent: :destroy
  has_many :budget_items, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :deadlines, dependent: :destroy
  has_many :finishes, dependent: :destroy
  has_many :project_organizations, dependent: :destroy
  has_many :organizations, through: :project_organizations
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users

  # monetize :total_budget_cents
  # monetize :selected_total_amount_cents

  def total_budget=

  end

  def total_budget
  end

  validates :name, presence: true, length: { maximum: 255 }

  def self.with_notifiable_deadlines
    # how long before a due date should we notify
    notification_range = 1.week
    # how often to notify
    notification_window = 3.days

    due_date_start = Date.today
    due_date_end   = due_date_start + notification_range
    notified_at  = Time.now - notification_window

    joins(:deadlines).where(deadlines: { complete: false })
    .where("deadlines.due_date > ?", due_date_start)
    .where("deadlines.due_date < ?", due_date_end)
    .where("projects.deadline_notification_sent_at IS NULL OR projects.deadline_notification_sent_at < ?", notified_at)
  end

  def owners
    users.where(project_users: { role: "owner" })
  end
  alias :finish_selectors :owners

  def collaborators
    users.where(project_users: { role: "collaborator" })
  end

  def selected_finishes
    finishes.selected
  end

  def calculate_selected_total_amount
    selected_finishes.inject(Money.new 0) do |total, finish|
      finish.quantity * finish.price + total
    end
  end

  def set_selected_total_amount!
    self.selected_total_amount = calculate_selected_total_amount
    save!
  end

  def budget_for_category(category_id)
    Money.new budget_items.filter_by_category(category_id).sum(:amount_cents)
  end

  def calculate_total_budget
    Money.new budget_items.sum(:amount_cents)
  end

  def set_total_budget!
    self.total_budget = calculate_total_budget
    save!
  end

  def set_deadline_notification_sent_at!
    self.deadline_notification_sent_at = Time.now
    save!
  end

end
