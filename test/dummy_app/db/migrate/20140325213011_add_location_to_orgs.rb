class AddLocationToOrgs < ActiveRecord::Migration
  def change
    add_column :organizations, :location,    :text
    add_column :organizations, :description, :text
  end
end
