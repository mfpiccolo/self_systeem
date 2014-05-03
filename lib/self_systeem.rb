require "self_systeem/version"
require "self_systeem/affirmation_builder"

module MinitestVcr
  def self.included(base)
    base.send(:include, SelfSysteem::AffirmationBuilder)
    super
  end
end
