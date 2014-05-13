case File.expand_path(__FILE__)
when /staging/
  set :environment, "staging"
when /production/
  set :environment, "production"
end

set :user,   "deploy"
set :path,   "/applications/finishes/#{environment}/current"
set :output, "#{path}/log/cron_whenever.log"

# Backup PostgreSQL database to S3 daily at 2am PST / 3am PDT
every 1.day, at: "10am" do
  command "cd #{path}; bundle exec dotenv backup perform -t postgres -c #{path}/config/backup.rb"
end


every 1.day, at: "8am" do
  command "cd #{path}; bundle exec send_deadline_notifications"
end
