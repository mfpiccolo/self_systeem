class CreateProjectOrganizations < ActiveRecord::Migration
  def change
    create_table :project_organizations do |t|
      t.references  :project, null: false
      t.foreign_key :projects
      t.references  :organization, null: false
      t.foreign_key :organizations

      t.timestamps
    end

    add_index :project_organizations, :id
    add_index :project_organizations, :project_id
    add_index :project_organizations, :organization_id
    add_index :project_organizations, [:project_id, :organization_id],
      unique: true
  end
end
