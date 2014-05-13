namespace :foreman do

  desc "Export the Procfile to Ubuntu upstart scripts"
  task :export do
    export_cmd = "sudo bundle exec foreman export upstart /etc/init -a #{foreman_app} -u #{foreman_user} -l #{foreman_log} -d #{deploy_to!}/current"

    queue %{
      echo "-----> Exporting foreman procfile for #{foreman_app}"
      #{echo_cmd %[cd #{deploy_to!}/#{current_path!} ; #{export_cmd}]}
    }
  end

  File.readlines("Procfile").map{ |line| line.split(": ").first }.each do |p|
    set_default "foreman_#{p}_app".to_sym, -> { "#{settings.foreman_app}-#{p}" }

    namespace p.to_sym do
      desc "Start the #{p} services"
      task :start do
        queue %{
          echo "-----> Starting #{p} services"
          #{echo_cmd %[sudo start #{send("foreman_#{p}_app")}]}
        }
      end

      desc "Stop the #{p} services"
      task :stop do
        queue %{
          echo "-----> Stopping #{p} services"
          #{echo_cmd %[sudo stop #{send("foreman_#{p}_app")}]}
        }
      end

      desc "Restart the #{p} services"
      task :restart do
        queue %{
          echo "-----> Restarting #{p} services"
          #{echo_cmd %[sudo start #{send("foreman_#{p}_app")} || sudo restart #{send("foreman_#{p}_app")}]}
        }
      end
    end
  end

end
