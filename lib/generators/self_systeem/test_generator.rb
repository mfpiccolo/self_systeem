require "rails/generators/active_record"

module SelfSysteem
  module Generators
    class TestGenerator < Rails::Generators::Base

      source_root File.expand_path("../templates", __FILE__)

      def add_test_and_support
        copy_file "systeem_config.rb", "test/system/support/systeem_config.rb"
        copy_file "systeem_test.rb", "test/system/systeem_test.rb"
      end

    end
  end
end
