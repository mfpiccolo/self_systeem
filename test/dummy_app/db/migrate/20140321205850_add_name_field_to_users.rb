class AddNameFieldToUsers < ActiveRecord::Migration
  def up
    add_column :users, :name, :string, default: "User Name", null: false

    remove_column :users, :first_name
    remove_column :users, :last_name

    change_column_default :users, :name, nil
  end

  def down
    remove_column :users, :name
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
  end
end
