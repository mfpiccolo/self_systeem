class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references  :finish, null: false
      t.foreign_key :finishes
      t.references  :user, null: false
      t.foreign_key :users
      t.text        :body
      t.timestamps
    end

    add_index :comments, :id
    add_index :comments, :finish_id
    add_index :comments, :user_id
    add_index :comments, :created_at
  end
end
