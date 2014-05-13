class AddCommentsCountToDummyApp < ActiveRecord::Migration
  def change
    add_column :finishes, :comments_count, :integer, default: 0
  end
end
