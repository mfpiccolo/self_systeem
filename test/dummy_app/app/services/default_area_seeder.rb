require "seeder_base"

class DefaultAreaSeeder < SeederBase

  def initialize(organization, names = Rails.configuration.default_area_names)
    super(target: organization, names: names)
  end

  def seed_record(name)
    DefaultArea.create organization: target, name: name
  end

  def self.seed(organization, names = Rails.configuration.default_area_names)
    new(organization, names).seed
  end

end
