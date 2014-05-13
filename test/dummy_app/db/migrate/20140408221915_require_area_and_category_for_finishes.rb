class RequireAreaAndCategoryForDummyApp < ActiveRecord::Migration
  def up
    Finish.all.each do |finish|
      next if finish.area_id.present? && finish.category_id.present?

      finish.area     = finish.project.areas.sample
      finish.category = finish.project.categories.sample
      finish.save!
    end

    change_column :finishes, :area_id, :integer, null: false
    change_column :finishes, :category_id, :integer, null: false
  end

  def down
    remove_column :finishes, :area_id
    remove_column :finishes, :category_id
  end
end
