# This migration comes from thincloud_authentication (originally 20130505230811)
class AddPasswordResetTokenToIdentities < ActiveRecord::Migration
  def change
    add_column :thincloud_authentication_identities, :password_reset_token,
      :string, default: nil
    add_column :thincloud_authentication_identities, :password_reset_sent_at,
      :datetime, default: nil
  end
end
