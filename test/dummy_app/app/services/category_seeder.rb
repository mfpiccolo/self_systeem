require "seeder_base"

class CategorySeeder < SeederBase

  def initialize(project, names = Rails.configuration.default_category_names)
    super(target: project, names: names)
  end

  def seed_record(name)
    Category.create project: target, name: name
  end

  def self.seed(project, names = Rails.configuration.default_category_names)
    new(project, names).seed
  end

end
