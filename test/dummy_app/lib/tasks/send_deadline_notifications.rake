desc "Send email notifications for projects with approaching incomplete deadlines"
task send_deadline_notifications: :environment do
  DeadlineNotifier.call
end
