class DeadlineMailer < ActionMailer::Base
  default from: "support@dummyapp.com"


  def notify(project_id)
    @project = Project.find(project_id)
    recipients = @project.finish_selectors.map(&:email)
    mail to: recipients, subject: "A DummyApp project has an approaching deadline."
  end
end
