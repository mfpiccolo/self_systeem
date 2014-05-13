class MergeFinishAttachmentsIntoProjectAttachments < ActiveRecord::Migration
  def up
    change_table :project_attachments do |t|
      t.references  :finish, null: true
      t.foreign_key :finishes
    end

    add_index :project_attachments, :finish_id
    drop_table :finish_attachments
  end

  def down
    remove_column :project_attachments, :finish_id

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
