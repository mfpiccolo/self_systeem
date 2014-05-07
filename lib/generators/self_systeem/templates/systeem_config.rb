ENV["RAILS_ENV"] = "test"
require File.expand_path("../../../../config/environment", __FILE__)
require "minitest/spec"
require "cell/test_case"
require "rails/test_help"
require "minitest/spec"
Dir[File.join("./test/support/**/authentication.rb")].sort.each { |f| require f }

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean_with :truncation

class ActionController::TestCase
  self.use_transactional_fixtures = false
end

module SysteemConfig
  Features = Dir["./test/system/support/affirmations/**/*.yml"].reject {|f| f[/_db|_session/]}
  Session = ActionController::TestSession.new
end

if defined? Devise::TestHelpers
  class ActionController::TestCase
    include Devise::TestHelpers
  end
end

