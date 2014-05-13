ENV["RAILS_ENV"] = "test"
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
  Features = Dir["./test/dummy_tests/system/support/affirmations/**/*.yml"].reject {|f| f[/_db|_session/]}
  Session = ActionController::TestSession.new
end

if defined? Devise::TestHelpers
  class ActionController::TestCase
    include Devise::TestHelpers
  end
end
