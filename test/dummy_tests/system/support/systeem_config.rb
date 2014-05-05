ENV["RAILS_ENV"] = "test"
# require File.expand_path("../../../../dummy_app/app/config/environment", __FILE__)
# require "cell/test_case"
require 'test_helper_dummy'
require "rails/test_help"
require "minitest/spec"
require "database_cleaner"

require 'coveralls'
Coveralls.wear!('rails')

Dir[File.join("./test/support/**/authentication.rb")].sort.each { |f| require f }

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean_with :truncation

class ActionController::TestCase
  self.use_transactional_fixtures = false
end

module SysteemConfig
  Affirmations = YAML.load_file("./test/dummy_tests/system/support/systeem_booster.yml")[:affirmations]
  Session = ActionController::TestSession.new
end
