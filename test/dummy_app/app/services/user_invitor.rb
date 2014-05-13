class UserInvitor

  def self.call(user)
    user.set_invitation_token!
    InvitationMailer.invite(user.id).deliver
  end

end
