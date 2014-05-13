class CreateDefaultAreas < ActiveRecord::Migration
  def change
    create_table :default_areas do |t|
      t.references  :organization, null: false
      t.foreign_key :organizations
      t.string      :name, null: false

      t.timestamps
    end

    add_index :default_areas, :id
    add_index :default_areas, :organization_id
  end
end
