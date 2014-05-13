class CreateBudgetItems < ActiveRecord::Migration
  def change
    create_table :budget_items do |t|
      t.references  :category, null: false
      t.foreign_key :categories
      t.references  :project, null: false
      t.foreign_key :projects
      t.references  :request_approver, null: true
      t.foreign_key :users, column: "request_approver_id"
      t.money       :amount

      t.timestamps
    end

    add_index :budget_items, :id
    add_index :budget_items, :category_id
    add_index :budget_items, :request_approver_id
  end
end
