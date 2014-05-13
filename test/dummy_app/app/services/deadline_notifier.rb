class DeadlineNotifier

  def self.call
    Project.with_notifiable_deadlines.uniq.each do |project|
      DeadlineMailer.notify(project.id)
      project.set_deadline_notification_sent_at!
    end
  end

end
