class RemoveApproverFromBudgetItems < ActiveRecord::Migration
  def up
    remove_column :budget_items, :request_approver_id
  end

  def down
    add_column :budget_items, :request_approver_id, :integer
    add_foreign_key :budget_items, :users, column: :request_approver_id
    add_index :budget_items, :request_approver_id
  end
end
