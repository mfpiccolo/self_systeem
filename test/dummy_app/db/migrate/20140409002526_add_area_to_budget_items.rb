class AddAreaToBudgetItems < ActiveRecord::Migration
  def up
    add_column :budget_items, :area_id, :integer

    BudgetItem.all.each do |item|
      item.area = item.project.areas.sample
      item.save!
    end

    change_column :budget_items, :area_id, :integer, null: false
    add_foreign_key :budget_items, :areas
    add_index :budget_items, :area_id
  end

  def down
    remove_column :budget_items, :area_id
  end
end
