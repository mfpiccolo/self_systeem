class CreateProjectUsers < ActiveRecord::Migration
  def change
    create_table :project_users do |t|
      t.references :project, null: false
      t.foreign_key :projects
      t.references :user, null: false
      t.foreign_key :users
      t.string     :role
      t.timestamps
    end

    add_index :project_users, :id
    add_index :project_users, :project_id
    add_index :project_users, :user_id
  end
end
