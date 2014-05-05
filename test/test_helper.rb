require 'dummy_app/init'
require 'support/shared_test_case_behavior'
require "minitest-spec-rails"
require "pry"

module MiniTestSpecRails
  class TestCase < MiniTest::Spec

    include MiniTestSpecRails::SharedTestCaseBehavior


  end
end
