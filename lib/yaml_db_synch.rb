require "yaml_db"

class YamlDbSynch
  def self.db_dump_data_file (ext = "yml", file = "data")
    "#{dump_dir}/#{file}_db.#{ext}"
  end

  def self.dump_dir
    "#{Rails.root}/test/system/support/affirmations"
  end

  def self.dump(file)
    format_class = ENV['class'] || "YamlDb::Helper"
    helper = format_class.constantize
    SerializationHelper::Base.new(helper).dump db_dump_data_file(helper.extension, file)
  end

  def self.load(file)
    format_class = ENV['class'] || "YamlDb::Helper"
    helper = format_class.constantize
    SerializationHelper::Base.new(helper).load file
  end

end
