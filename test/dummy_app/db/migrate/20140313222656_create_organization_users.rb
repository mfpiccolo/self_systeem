class CreateOrganizationUsers < ActiveRecord::Migration
  def change
    create_table :organization_users do |t|
      t.references  :organization, null: false
      t.foreign_key :organizations
      t.references  :user, null: false
      t.foreign_key :users
      t.string      :role, null: false

      t.timestamps
    end

    add_index :organization_users, :id
    add_index :organization_users, :organization_id
    add_index :organization_users, :user_id
    add_index :organization_users, [:organization_id, :user_id], unique: true
  end
end
