class AddContentTypeToProjectAttachments < ActiveRecord::Migration
  def change
    add_column :project_attachments, :content_type, :string
  end
end
