class CreateDefaultCategories < ActiveRecord::Migration
  def change
    create_table :default_categories do |t|
      t.references  :organization, null: false
      t.foreign_key :organizations
      t.string      :name, null: false

      t.timestamps
    end

    add_index :default_categories, :id
    add_index :default_categories, :organization_id
  end
end
