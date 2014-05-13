class SetFinishesQuantityDefault < ActiveRecord::Migration
  def up
    change_column :finishes, :quantity, :integer, null: false, default: 1
  end
end
