require 'test_helper'
require "devise"
require "devise_invitable"
require "sass"

class ActiveSupport::TestCase

  include MiniTestSpecRails::SharedTestCaseBehavior

end

class ActionController::TestCase
  include Devise::TestHelpers
end

