require "mina/bundler"
require "mina/rails"
require "mina/chruby"
require "mina/git"
require "mina/foreman"
require "mina/whenever"
Dir["./lib/recipes/*.rb"].each{ |recipe| require recipe }

set :stage,  ENV["stage"]  || "staging"
set :branch, ENV["branch"] || "master"

set :rails_env, stage

set :shared_paths, %w[config/database.yml log pids public/assets sockets .env .foreman Procfile]

set :application, "dummyapp"
set :foreman_app, -> { "#{application}-#{stage}" }
set :domain, -> { "dummyapp-#{stage}.dummyapp.com" }
set :deploy_to, -> { "/applications/#{application}/#{stage}" }
set :repository, "git@github.com:newleaders/dummyapp.git"

set :user, "deploy"
set :forward_agent, true

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # load the chruby environment
  invoke :"chruby[ruby-2.1.0]"
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task setup: :environment do
  %w[config log pids sockets public/assets].each do |dir|
    queue! %[mkdir -p "#{deploy_to}/shared/#{dir}"]
    queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/#{dir}"]
  end

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
end

namespace :deploy do
  desc "Deploys the current version to the server, also run as 'mina deploy'"
  task normal: :environment do
    deploy do
      invoke :"common_deploy"
      invoke :"whenever:update"

      to :launch do
        invoke :"foreman:export"
        invoke :"foreman:worker:restart"
        invoke :"puma:restart"
      end

      invoke :"deploy:cleanup"
    end
  end

  desc "Initial deploy the current version to the server."
  task cold: :environment do
    deploy do
      invoke :"common_deploy"

      to :launch do
        invoke :"foreman:export"
        invoke :"foreman:restart"
      end

      invoke :"deploy:cleanup"
    end
  end
end

task deploy: ["deploy:normal"]

desc "Restart the application services"
task restart: :environment do
  invoke :"foreman:worker:restart"
  invoke :"puma:restart"
end

desc "Clone a remote database locally"
namespace :db do
  task :pull do
    invoke :"db:pg:clone"
  end
end

# common deploy tasks for cold and normal deploy
task :common_deploy do
  invoke :"git:clone"
  invoke :"deploy:link_shared_paths"
  invoke :"bundle:install"
  invoke :"rails:db_migrate"
  invoke :"rails:assets_precompile"
  invoke :"copy_resque_web_assets"
end

task :copy_resque_web_assets do
  resque_assets       = "`bundle show resque`/lib/resque/server/public/*"
  resque_release_path = "public/resque"

  queue! %{
    echo "-----> Copying resque web assets" && (
      #{echo_cmd "mkdir -p ./#{resque_release_path}"} &&
      #{echo_cmd "cp #{resque_assets} ./#{resque_release_path}" }
    )
  }
end
