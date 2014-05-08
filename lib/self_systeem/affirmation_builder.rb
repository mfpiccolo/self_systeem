require "yaml_db_synch"

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

        # middleware api
        status, headers, response = @app.call(env)

        # setup vars for hash to test agains later
        request_path = env["REQUEST_PATH"]
        request_method = env["REQUEST_METHOD"]
        request_parameters = {}
        request_parameters.merge!(env["rack.request.form_hash"]) if env["rack.request.form_hash"].present?
        request_parameters.merge!(env["action_controller.instance"].params.try(:to_hash)) if env["action_controller.instance"].params.present?
        @controller_instance = env["action_controller.instance"]
        controller_class_name = @controller_instance.try(:class).try(:name)
        action = @controller_instance.action_name
        session = env["action_dispatch.request.unsigned_session_cookie"]
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

        # assign paths for dir and file names for session and affirmation files
        path = Rails.root.to_s + "/" + SelfSysteem.test_dir + "/system/support/affirmations/"
        affirmation_filename = ENV["SYSTEEM"] + ".yml"
        session_filename = ENV["SYSTEEM"] + "_session" + ".yml"
        if File.exist?(path + affirmation_filename)
          requirements = YAML.load_file(path + affirmation_filename)[:requirements]
        end

        # writes data to files as yaml
        unless File.exist?(path + affirmation_filename) && YAML.load_file(path + affirmation_filename)[:affirmations].present?
          full_path_dir = (path + affirmation_filename).match(/^(.*\/)?(?:$|(.+?)(?:(\.[^.]*$)|$))/)[1]
          FileUtils.mkdir_p full_path_dir
          File.open(path + affirmation_filename, "w") { |file| file.write({ requirements: [], affirmations: [] }.to_yaml) }
        end

        boosters = YAML.load_file(path + affirmation_filename)
        boosters[:requirements] = requirements if requirements.present?
        boosters[:affirmations] << booster

        File.open(path + affirmation_filename, 'w') do |file|
          file.write(boosters.to_yaml)
        end

        # Overwrites #{filename}_session.yml.  File ends up with the last session of the run.
        File.open(path + session_filename, "w") { |file| file.write(session.to_yaml) }

        # Dump the Database.  Overwrites to get the state of the database after the last run.
        YamlDbSynch.dump(ENV["SYSTEEM"])

        teardown_subscriptions
      end

      # response expected for middleware
      [status, headers, [response.try(:body)].flatten]
    end

    def setup_instance_varaibles
      builder = SelfSysteem::InstanceVariablesBuilder.call(@controller_instance)
      @relevant_instance_varaibles = builder.relevant_instance_varaibles
      @instance_variable_objects = builder.instance_variable_objects
    end

    def setup_subscriptions
      # setup the equivalend of event listeners to build instance variables.
      # exactly what ActonController::TestCase does

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
      # Removes event listeners
      ActiveSupport::Notifications.unsubscribe("render_template.action_view")
      ActiveSupport::Notifications.unsubscribe("!render_template.action_view")
    end

  end
end
