module SelfSysteem
  class AffirmationBuilder

    def initialize(app)
      @app = app
    end

    def call(env)
      if env["REQUEST_PATH"].match(/\/assets/)
        status, headers, response = @app.call(env)
      else
        status, headers, response = @app.call(env)
        request_path = env["REQUEST_PATH"]
        request_method = env["REQUEST_METHOD"]

        request_parameters = {}
        request_parameters.merge!(env["rack.request.form_hash"]) if env["rack.request.form_hash"].present?
        request_parameters.merge!(env["action_controller.instance"].params.try(:to_hash)) if env["action_controller.instance"].params.present?

        controller_instance = env["action_controller.instance"]
        controller_class_name = controller_instance.try(:class).try(:name)
        action = controller_instance.action_name

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

        booster = {request_method: request_method,
                          request_path: request_path,
                                action: action,
                    request_parameters: request_parameters,
                 controller_class_name: controller_class_name,
                                status: status,
           relevant_instance_varaibles: relevant_instance_varaibles.to_s,
             instance_variable_objects: instance_variable_objects
        }

        unless File.exist?(Rails.root.to_s + "/test/system/support/systeem_booster.yml")
          FileUtils.mkdir_p Rails.root.to_s + "/test/system/support"
          File.open(Rails.root.to_s + "/test/system/support/systeem_booster.yml", "w") { |file| file.write({ affirmations: [] }.to_yaml) }
        end

        boosters = YAML.load_file(Rails.root.to_s + "/test/system/support/systeem_booster.yml")
        boosters[:affirmations] << booster

        File.open(Rails.root.to_s + "/test/system/support/systeem_booster.yml", 'w') do |file|
          file.write(boosters.to_yaml)
        end
      end

      [status, headers, [response.try(:body)].flatten]
    end
  end
end
