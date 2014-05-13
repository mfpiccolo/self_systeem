base_dir = File.expand_path("../..", __FILE__).gsub(/releases\/\d+/, "current")
base_port = ENV["PORT"] || 3000

bind "tcp://127.0.0.1:#{base_port}"
daemonize false
directory base_dir
pidfile "#{base_dir}/pids/puma.pid"
rackup "#{base_dir}/config.ru"
state_path "#{base_dir}/pids/puma.state"
threads 2, 16
workers [`grep 'core id' /proc/cpuinfo 2>/dev/null | wc -l`.chomp.strip.to_i, 1].max

activate_control_app "unix://#{base_dir}/sockets/pumactl.sock", { no_token: true }

preload_app!

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
