ENV["RAILS_ENV"] = "test"
require File.expand_path("../../../../config/environment", __FILE__)
require "minitest/spec"
require "rails/test_help"
require "minitest/spec"

# TODO application specific.  Need to remove
Dir[File.join("./" + SelfSysteem.test_dir + "/support/**/authentication.rb")].sort.each { |f| require f }

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
