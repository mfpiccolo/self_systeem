require "rails/generators/active_record"

module SelfSysteem
  module Generators
    class TestGenerator < Rails::Generators::Base

      source_root File.expand_path("../templates", __FILE__)

      def add_test_and_support
        copy_file "systeem_config.rb", SelfSysteem.test_dir + "/system/support/systeem_config.rb"
        copy_file "systeem_" + Systeem.test_framework +".rb", SelfSysteem.test_dir + "/system/systeem_" + Systeem.test_dir +".rb"
      end

    end
  end
end
