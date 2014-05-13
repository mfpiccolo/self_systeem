class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.references  :project, null: false
      t.foreign_key :projects
      t.string      :name
      t.timestamps
    end

    add_index :areas, :id
    add_index :areas, :project_id
    add_index :areas, [:project_id, :name], unique: true
  end
end
