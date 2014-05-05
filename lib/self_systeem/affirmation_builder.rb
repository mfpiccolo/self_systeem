module SelfSysteem
  class AffirmationBuilder

    def initialize(app)
      @app = app
    end

    def call(env)

      if env["REQUEST_PATH"].match(/\/assets/)
        status, headers, response = @app.call(env)
      else
        setup_subscriptions
        status, headers, response = @app.call(env)
        request_path = env["REQUEST_PATH"]
        request_method = env["REQUEST_METHOD"]

        request_parameters = {}
        request_parameters.merge!(env["rack.request.form_hash"]) if env["rack.request.form_hash"].present?
        request_parameters.merge!(env["action_controller.instance"].params.try(:to_hash)) if env["action_controller.instance"].params.present?

        @controller_instance = env["action_controller.instance"]
        controller_class_name = @controller_instance.try(:class).try(:name)
        action = @controller_instance.action_name

        setup_instance_varaibles

        booster = {request_method: request_method,
                          request_path: request_path,
                                action: action,
                    request_parameters: request_parameters,
                 controller_class_name: controller_class_name,
                                status: status,
                              partials: @_partials,
                               layouts: @_layouts,
                             templates: @_templates,
                                 files: @_files,
           relevant_instance_varaibles: @relevant_instance_varaibles.to_s,
             instance_variable_objects: @instance_variable_objects
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

        teardown_subscriptions
      end

      [status, headers, [response.try(:body)].flatten]
    end

    def setup_instance_varaibles
      builder = SelfSysteem::InstanceVariablesBuilder.call(@controller_instance)
      @relevant_instance_varaibles = builder.relevant_instance_varaibles
      @instance_variable_objects = builder.instance_variable_objects
    end

    def setup_subscriptions
      @_partials = Hash.new(0)
      @_templates = Hash.new(0)
      @_layouts = Hash.new(0)
      @_files = Hash.new(0)

      ActiveSupport::Notifications.subscribe("render_template.action_view") do |_name, _start, _finish, _id, payload|
        path = payload[:layout]
        if path
          @_layouts[path] += 1
          if path =~ /^layouts\/(.*)/
            @_layouts[$1] += 1
          end
        end
      end

      ActiveSupport::Notifications.subscribe("!render_template.action_view") do |_name, _start, _finish, _id, payload|
        path = payload[:virtual_path]
        next unless path
        partial = path =~ /^.*\/_[^\/]*$/

        if partial
          @_partials[path] += 1
          @_partials[path.split("/").last] += 1
        end

        @_templates[path] += 1
      end

      ActiveSupport::Notifications.subscribe("!render_template.action_view") do |_name, _start, _finish, _id, payload|
        next if payload[:virtual_path] # files don't have virtual path

        path = payload[:identifier]
        if path
          @_files[path] += 1
          @_files[path.split("/").last] += 1
        end
      end
    end

    def teardown_subscriptions
      ActiveSupport::Notifications.unsubscribe("render_template.action_view")
      ActiveSupport::Notifications.unsubscribe("!render_template.action_view")
    end

  end
end
