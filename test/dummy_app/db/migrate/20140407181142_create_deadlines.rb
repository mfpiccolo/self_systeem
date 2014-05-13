class CreateDeadlines < ActiveRecord::Migration
  def change
    create_table :deadlines do |t|
      t.references  :area, null: false
      t.foreign_key :areas
      t.references  :category, null: false
      t.foreign_key :categories
      t.references  :project, null: false
      t.foreign_key :projects
      t.date        :due_date, null: false
      t.text        :description

      t.timestamps
    end

    add_index :deadlines, :id
    add_index :deadlines, :area_id
    add_index :deadlines, :category_id
  end
end
