require "./test/system/support/systeem_config.rb"

describe "start_db_cleaner" do
  before { DatabaseCleaner.start }
end

SysteemConfig::Affirmations.each do |a|
  describe a[:controller_class_name].constantize do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      send(a[:request_method].downcase.to_sym, a[:action], a[:request_parameters], SysteemConfig::Session)
      SysteemConfig::Session.merge! session
    end

    it {
      assert_response a[:status]

    }
  end
end

describe "db_cleaner_clean" do
  before { DatabaseCleaner.clean }
end
