class CreateFinishes < ActiveRecord::Migration
  def change
    create_table :finishes do |t|
      t.references  :project, null: false
      t.foreign_key :projects
      t.references  :area, null: true
      t.foreign_key :areas
      t.references  :category, null: true
      t.foreign_key :categories
      t.string      :name
      t.string      :location
      t.string      :model
      t.integer     :quantity
      t.money       :price
      t.text        :description
      t.timestamps
    end

    add_index :finishes, :id
    add_index :finishes, :project_id
    add_index :finishes, [:project_id, :name], unique: true
  end
end
