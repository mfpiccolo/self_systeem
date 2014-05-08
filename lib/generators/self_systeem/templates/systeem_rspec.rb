require "./spec/spec_helper"
require "./" + SelfSysteem.test_dir + "/system/support/systeem_config.rb"

SysteemConfig::Features.each do |f|

  describe "start_db_cleaner" do
    it {
      DatabaseCleaner.start
      DatabaseCleaner.clean
    }
  end

  # Load database if _db exists
  file_hash = YAML.load_file f

  if file_hash[:requirements].last.present?
    db_filename = "./" + SelfSysteem.test_dir + "/system/support/affirmations/" + file_hash[:requirements].last + "_db.yml"
    session_filename = "./" + SelfSysteem.test_dir + "/system/support/affirmations/" + file_hash[:requirements].last + "_session.yml"
  end

  file_hash[:affirmations].each_with_index do |a, i|
    describe a[:controller_class_name].constantize, type: :controller do

      before do
        # If it is ths first run, set the session and the database
        if file_hash[:requirements].present? && i == 0 && File.exist?(db_filename) && File.exist?(session_filename)
          saved_session = YAML.load_file(session_filename).reject {|k| k.to_s.match(/session_id|_csrf_token/)}
          SysteemConfig::Session.merge!(saved_session)
          YamlDbSynch.load(db_filename)
        end

        Rails.application.load_seed

        # Only needed if devise
        # @request.env["devise.mapping"] = Devise.mappings[:user] if defined? Devise

        SysteemConfig::Session.merge! session
      end

      it {
        send(a[:request_method].downcase.to_sym, a[:action], a[:request_parameters], SysteemConfig::Session)
        controller_instance = response.request.env["action_controller.instance"] || self.instance_variable_get(:@controller)
        builder = SelfSysteem::InstanceVariablesBuilder.call(controller_instance)
        relevant_instance_varaibles = builder.relevant_instance_varaibles
        instance_variable_objects = builder.instance_variable_objects

        expect(response.status).to   eq a[:status]
        expect(a[:relevant_instance_varaibles]).to eq relevant_instance_varaibles.to_s
        expect(a[:instance_variable_objects]).to eq instance_variable_objects
        expect(a[:templates].except(*a[:partials].keys)).to eq @_templates
      }
    end
  end

  describe "db_cleaner_clean" do
    it {
      DatabaseCleaner.start
      DatabaseCleaner.clean
    }
  end
end
