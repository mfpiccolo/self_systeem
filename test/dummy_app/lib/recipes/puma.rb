# Modules: puma
# Adds settings and tasks for managing [puma] application server.
#
# [puma]: https://github.com/puma/puma
#
#     require "mina/puma"
#
# ## Common usage
#
#     task :deploy => :environment do
#       ...
#     end


# ## Tasks
set_default :puma_current_path, -> { "#{deploy_to}/current" }

namespace :puma do
  desc "Start the application"
  task start: :environment do
    queue %{
      echo "-----> Start Puma"
      #{echo_cmd %(cd #{puma_current_path} && RAILS_ENV=#{stage} bundle exec puma -C #{puma_current_path}/config/puma.rb)}
    }
  end

  desc "Stop the application"
  task stop: :environment do
    queue %{
      echo "-----> Stop Puma"
      #{echo_cmd %(cd #{puma_current_path} && bundle exec pumactl -C unix://#{puma_current_path}/sockets/pumactl.sock stop)}
    }
  end

  desc "Restart the application"
  task restart: :environment do
    queue %{
      echo "-----> Restart Puma"
      #{echo_cmd %(cd #{puma_current_path} && bundle exec pumactl -C unix://#{puma_current_path}/sockets/pumactl.sock restart)}
    }
  end
end
