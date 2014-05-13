require "seeder_base"

class AreaSeeder < SeederBase

  def initialize(project, names = Rails.configuration.default_area_names)
    super(target: project, names: names)
  end

  def seed_record(name)
    Area.create project: target, name: name
  end

  def self.seed(project, names = Rails.configuration.default_area_names)
    new(project, names).seed
  end

end
