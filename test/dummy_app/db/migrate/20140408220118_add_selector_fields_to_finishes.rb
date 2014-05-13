class AddSelectorFieldsToFinishes < ActiveRecord::Migration
  def up
    Finish.all.each do |finish|
      finish.selected = false
      finish.save!
    end

    add_column :finishes, :selected_by_id, :integer
    add_foreign_key :finishes, :users, column: :selected_by_id
    add_column :finishes, :selected_at, :datetime
    add_index :finishes, :selected_by_id
  end

  def down
    remove_column :finishes, :selected_by_id
    remove_column :finishes, :selected_at
  end
end
