if ENV["SYSTEEM"].present?
  module ActionController
    class Base
      before_filter :set_theme

      def set_theme
        session["run_count"] = 0 unless session["run_count"].present?
        session["run_count"] += 1

        if session["run_count"] <= 1
          affirmation_path = "./" + SelfSysteem.test_dir + "/system/support/affirmations/" + ENV["SYSTEEM"] + ".yml"

          if File.exist?(affirmation_path)
            affirmation_requirements = YAML.load_file(affirmation_path)[:requirements].last

            session_path = ("./" + SelfSysteem.test_dir + "/system/support/affirmations/" +
                                             affirmation_requirements.to_s +
                                             "_session.yml")

            db_path = ("./" + SelfSysteem.test_dir + "/system/support/affirmations/" +
                                             affirmation_requirements.to_s +
                                             "_db.yml")

            if File.exist?(session_path)
              systeem_session = YAML.load_file(session_path)

              systeem_session.each_pair do |k, v|
                unless ["session_id", "_csrf_token"].include?(k)
                  session[k] ||= systeem_session[k]
                end
              end
            end

            if File.exist?(db_path)
              YamlDbSynch.load(db_path)
            end
          else
            Rails.application.load_seed
          end

        end

      end
    end
  end
end
