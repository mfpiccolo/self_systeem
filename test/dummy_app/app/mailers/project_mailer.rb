class ProjectMailer < ActionMailer::Base
  default from: "support@finishesapp.com"


  def share(user_id, project_id)
    @user = User.find(user_id)
    @project = Project.find(project_id)
    mail to: @user.email, subject: "A DummyApp project has been shared with you."
  end
end
