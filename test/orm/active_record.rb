ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)

ActiveRecord::Migrator.migrate(File.expand_path("../../dummy_app/db/migrate/", __FILE__))
