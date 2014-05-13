# Reload development database
namespace :db do

  # postgresql databases
  namespace :pg do

    desc "Dump the database to a compressed archive"
    task :dump_archive do
      queue! %{
        PGPASSWORD=`grep password #{deploy_to}/shared/config/database.yml | \
          cut -d' ' -f4` \
        pg_dump -O -U #{application} -h localhost #{application}_#{stage} | \
          bzip2 -9 > ~/pg_dump.sql.bz2
      }
    end

    desc "Remove the compressed database archive"
    task :remove_archive do
      queue! "rm -f ~/pg_dump.sql.bz2"
    end

    desc "Reload development database from stage"
    task :clone do
      clone_env = ENV["RAILS_ENV"] || "development"
      local_db  = "#{application}_#{clone_env}"

      commands = [
        "mina db:pg:dump_archive",
        "scp #{user}@#{domain}:~/pg_dump.sql.bz2 tmp/",
        "dropdb #{local_db}",
        "createdb #{local_db}",
        "echo 'restoring pg_dump'",
        "bzcat tmp/pg_dump.sql.bz2 | psql #{local_db} >/dev/null",
        "mina db:pg:remove_archive"
      ]

      system commands.join(" && ")
    end

  end  # pg
end  # db
