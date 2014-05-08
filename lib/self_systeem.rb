require "self_systeem/version"
require "self_systeem/affirmation_builder"
require "self_systeem/instance_variables_builder"
require "self_systeem/configuration"
require "yaml_db"
require "action_controller_monkey"

module SelfSysteem
  extend Configure

  def self.included(base)
    base.send(:include, SelfSysteem::AffirmationBuilder)
    base.send(:include, SelfSysteem::InstanceVariablesBuilder)
    super
  end

  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path('../tasks/yaml_db_tasks.rake',
__FILE__)
    end
  end
end
