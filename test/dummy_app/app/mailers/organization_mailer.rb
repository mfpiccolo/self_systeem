class OrganizationMailer < ActionMailer::Base
  default from: "support@finishesapp.com"


  def share(user_id, organization_id)
    @user = User.find(user_id)
    @organization = Organization.find(organization_id)
    mail to: @user.email, subject: "A DummyApp organization has been shared with you."
  end
end
