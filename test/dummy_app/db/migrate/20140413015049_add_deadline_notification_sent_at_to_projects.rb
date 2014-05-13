class AddDeadlineNotificationSentAtToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :deadline_notification_sent_at, :datetime
  end
end
