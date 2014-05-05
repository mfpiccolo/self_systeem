require "self_systeem/version"
require "self_systeem/affirmation_builder"
require "self_systeem/instance_variables_builder"

module SelfSysteem
  def self.included(base)
    base.send(:include, SelfSysteem::AffirmationBuilder)
    base.send(:include, SelfSysteem::InstanceVariablesBuilder)
    super
  end
end
