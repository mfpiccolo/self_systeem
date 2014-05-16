# require "test_helper"
# require "self_systeem"
# require "mocha"

# describe SiteController do
#   before do
#     @app = Rails.application
#     get(:index)
#     @ab = SelfSysteem::AffirmationBuilder.new(app)
#     @request.env.merge!({ "REQUEST_PATH" => "/", "REQUEST_METHOD" => "GET", "PATH_INFO" => "/" })
#     ENV["SYSTEEM"] = "some_feature"
#     @path = Rails.root.to_s + "/" + SelfSysteem.test_dir + "/system/support/affirmations/"
#     FileUtils.stubs(:mkdir_p).with(@path)
#   end

#   it {
#     assert !(File.exists?(@path + "some_feature_db.yml"))
#     assert !(File.exists?(@path + "some_feature_session.yml"))
#     @ab.call(@request.env)
#     assert File.exists?(@path + "some_feature.yml")
#     assert File.exists?(@path + "some_feature_db.yml")
#     assert File.exists?(@path + "some_feature_session.yml")
#     File.delete(@path + "some_feature_db.yml")
#     File.delete(@path + "some_feature_session.yml")
#   }
# end
