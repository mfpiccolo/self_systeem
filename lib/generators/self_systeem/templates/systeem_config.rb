ENV["RAILS_ENV"] = "test"
require File.expand_path("../../../../config/environment", __FILE__)
if Systeem.test_framework == "minitest"
  require "minitest/spec"
  require "minitest/spec"
end
require "rails/test_help"

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean_with :truncation

module SysteemConfig
  Features = Dir["./" + SelfSysteem.test_dir + "/system/support/affirmations/**/*.yml"].reject {|f| f[/_db|_session/]}
  Session = ActionController::TestSession.new
end

if defined? Devise::TestHelpers
  class ActionController::TestCase
    include Devise::TestHelpers
  end
end
