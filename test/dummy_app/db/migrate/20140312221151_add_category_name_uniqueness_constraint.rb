class AddCategoryNameUniquenessConstraint < ActiveRecord::Migration
  def change
    add_index :categories, [:project_id, :name], unique: true
  end
end
