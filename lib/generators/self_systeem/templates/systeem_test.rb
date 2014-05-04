require "./test/system/support/systeem_config.rb"

describe "start_db_cleaner" do
  before { DatabaseCleaner.start }
end

SysteemConfig::Affirmations.each do |a|
  describe a[:controller_class_name].constantize do
    before do
      # Only needed if devise
      @request.env["devise.mapping"] = Devise.mappings[:user]
      send(a[:request_method].downcase.to_sym, a[:action], a[:request_parameters], SysteemConfig::Session)
      SysteemConfig::Session.merge! session
    end

    it {
      # Move this somewhere, also used in affirmation_builder.rb
      controller_instance = response.request.env["action_controller.instance"]
      relevant_instance_varaibles = controller_instance
        .instance_variable_names.reject {|v| v[/@_/] || v == "@marked_for_same_origin_verification"}
      instance_variable_objects = {}
      relevant_instance_varaibles.each do |v|
        iv_val = controller_instance.instance_variable_get(v)
        if iv_val.class.name.match(/ActiveRecord::AssociationRelation|ActiveRecord::Associations::CollectionProxy/)
          instance_variable_objects.merge!(v.to_s => { })
          iv_val.each do |o|
            instance_variable_objects[v.to_s].merge!({ o.to_s => o.attributes })
          end
        elsif iv_val.is_a?(ActiveRecord::Base)
          instance_variable_objects.merge!({ v.to_s => iv_val.attributes })
        else
          instance_variable_objects.merge!({ v.to_s => iv_val.to_s })
        end
      end

      assert_response a[:status]
      assert_equal(a[:relevant_instance_varaibles], relevant_instance_varaibles.to_s)
      # TODO only the keys match, should match the counts as well
      assert_equal(a[:templates].keys, @_templates.keys)
    }
  end
end

describe "db_cleaner_clean" do
  before { DatabaseCleaner.clean }
end
