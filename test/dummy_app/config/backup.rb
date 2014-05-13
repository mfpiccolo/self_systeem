desc =  "Postgres Daily SQL Dump Backup configuration for "
desc += "#{ENV["BACKUP_APP_NAME"]}-#{ENV["RAILS_ENV"]}"

Backup::Model.new(:postgres, desc) do

  DB = YAML.load_file(File.expand_path("../database.yml", __FILE__))[ENV["RAILS_ENV"]]

  database PostgreSQL do |db|
    db.name               = DB["database"]
    db.username           = DB["username"]
    db.password           = DB["password"]
    db.host               = DB["host"]   if DB["host"]
    db.port               = DB["port"]   if DB["port"]
    db.socket             = DB["socket"] if DB["socket"]
    # db.skip_tables        = ["skip", "these", "tables"]
    # db.only_tables        = ["only", "these" "tables"]
    # db.additional_options = ["--opt"]
  end

  encrypt_with OpenSSL do |encryption|
    encryption.password = ENV["BACKUP_ENCRYPTION_PASSWORD"]
  end

  compress_with Gzip do |compression|
    compression.level = 9
  end

  store_with S3 do |s3|
    s3.access_key_id     = ENV["BACKUP_ACCESS_KEY_ID"]
    s3.secret_access_key = ENV["BACKUP_SECRET_ACCESS_KEY"]
    s3.region            = ENV["BACKUP_REGION"]
    s3.bucket            = ENV["BACKUP_BUCKET"]
    s3.path              = ENV["BACKUP_PATH"]
    s3.keep              = ENV["BACKUP_KEEP"]
  end

  notify_by Mail do |mail|
    mail.on_success = false
    mail.on_failure = true

    mail.from                 = "Agilebox <smtp@agilebox.com>"
    mail.to                   = "backups+#{ENV["BACKUP_APP_NAME"]}@newleaders.com"
    mail.address              = "smtp.postmarkapp.com"
    mail.domain               = "agilebox.com"
    mail.user_name            = ENV["AGILEBOX_POSTMARK"]
    mail.password             = ENV["AGILEBOX_POSTMARK"]
    mail.port                 = 2525
    mail.authentication       = "plain"
    mail.enable_starttls_auto = true
  end

end
