class RemoveTcAuth < ActiveRecord::Migration
  def up
    drop_table :thincloud_authentication_identities
  end

  def down
    create_table :thincloud_authentication_identities do |t|
      t.integer :user_id, null: false
      t.string :provider, null: false, default: "identity"
      t.string :uid
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :verification_token
      t.datetime :verified_at

      t.timestamps
    end
    add_index :thincloud_authentication_identities, :user_id
    add_index :thincloud_authentication_identities, [:provider, :uid], unique: true
    add_index :thincloud_authentication_identities, :email

    add_column :thincloud_authentication_identities, :password_reset_token,
      :string, default: nil
    add_column :thincloud_authentication_identities, :password_reset_sent_at,
      :datetime, default: nil
  end
end
