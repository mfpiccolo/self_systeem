class CreateFinishAttachments < ActiveRecord::Migration
  def change
    create_table :finish_attachments do |t|
      t.references  :finish, null: false
      t.foreign_key :finishes
      t.string      :file

      t.timestamps
    end

    add_index :finish_attachments, :id
    add_index :finish_attachments, :finish_id
  end
end
