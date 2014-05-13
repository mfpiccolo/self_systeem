class CreateProjectAttachments < ActiveRecord::Migration
  def change
    create_table :project_attachments do |t|
      t.references  :project, null: false
      t.foreign_key :projects
      t.string      :file

      t.timestamps
    end

    add_index :project_attachments, :id
    add_index :project_attachments, :project_id
  end
end
