class AddSelectedTotalAmountToProjects < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.money :selected_total_amount
    end
  end
end
