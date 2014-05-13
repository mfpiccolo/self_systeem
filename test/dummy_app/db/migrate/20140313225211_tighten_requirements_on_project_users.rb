class TightenRequirementsOnProjectUsers < ActiveRecord::Migration
  def up
    change_column :project_users, :role, :string, null: false
    add_index :project_users, [:project_id, :user_id], unique: true
  end

  def down
    change_column :project_users, :role, :string
    remove_index :project_users, [:project_id, :user_id]
  end
end
