class AddIndexToProjectsId < ActiveRecord::Migration
  def change
    add_index :projects, :id
  end
end
