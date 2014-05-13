class AddSelectedToFinishes < ActiveRecord::Migration
  def change
    add_column :finishes, :selected, :boolean, default: false
  end
end
