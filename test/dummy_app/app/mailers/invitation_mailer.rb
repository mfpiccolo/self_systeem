class InvitationMailer < ActionMailer::Base
  default from: "support@finishesapp.com"

  def invite(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "You have been invited to DummyAppApp.com"
  end

end
