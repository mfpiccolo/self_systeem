ENV["RAILS_ENV"] = "test"
require File.expand_path("../../../../config/environment", __FILE__)
require "minitest/spec"
require "rails/test_help"
require "minitest/spec"
Dir[File.join("./test/support/**/authentication.rb")].sort.each { |f| require f }

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean_with :truncation

class ActionController::TestCase
  self.use_transactional_fixtures = false
end

module SysteemConfig
  Affirmations = YAML.load_file("./test/system/support/systeem_booster.yml")[:affirmations]
  Session = ActionController::TestSession.new
end
