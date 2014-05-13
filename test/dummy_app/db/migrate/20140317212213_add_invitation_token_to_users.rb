class AddInvitationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invitation_token, :string
  end
end
