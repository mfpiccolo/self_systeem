require "./test/dummy_tests/system/support/systeem_config.rb"

describe "start_db_cleaner" do
  it { DatabaseCleaner.start }
end

SysteemConfig::Affirmations.each do |a|
  describe a[:controller_class_name].constantize do
    before do
      # Only needed if devise
      # @request.env["devise.mapping"] = Devise.mappings[:user]
      send(a[:request_method].downcase.to_sym, a[:action], a[:request_parameters], SysteemConfig::Session)
      SysteemConfig::Session.merge! session
    end

    it {
      controller_instance = response.request.env["action_controller.instance"] || @controller
      builder = SelfSysteem::InstanceVariablesBuilder.call(controller_instance)
      relevant_instance_varaibles = builder.relevant_instance_varaibles
      instance_variable_objects = builder.instance_variable_objects

      assert_response a[:status]
      assert_equal(a[:relevant_instance_varaibles], relevant_instance_varaibles.to_s)
      assert_equal(a[:instance_variable_objects], instance_variable_objects)
      assert_equal(a[:templates], @_templates)
    }
  end
end

describe "db_cleaner_clean" do
  it { DatabaseCleaner.clean }
end
