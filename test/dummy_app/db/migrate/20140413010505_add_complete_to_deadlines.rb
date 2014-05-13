class AddCompleteToDeadlines < ActiveRecord::Migration
  def up
    add_column :deadlines, :complete, :boolean, default: false

    Deadline.all.each { |d| d.set_completion_status! }
  end

  def down
    remove_column :deadlines, :complete
  end

end
