class AddLocaitonAndBudgetToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :location,     :text
    add_column :projects, :total_budget_cents, :integer, default: 0
  end
end
