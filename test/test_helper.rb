# require 'dummy_app/init'
require "dummy_app/config/environment"
DEVISE_ORM = (ENV["DEVISE_ORM"] || :active_record).to_sym
require "orm/#{DEVISE_ORM}"
require 'rails/test_help'
require 'support/shared_test_case_behavior'
require "minitest-spec-rails"
require "pry"

module MiniTestSpecRails
  class TestCase < MiniTest::Spec

    include MiniTestSpecRails::SharedTestCaseBehavior

  end
end
