class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.references  :project, null: false
      t.foreign_key :projects
      t.string      :name
      t.timestamps
    end

    add_index :categories, :id
    add_index :categories, :project_id
  end
end
