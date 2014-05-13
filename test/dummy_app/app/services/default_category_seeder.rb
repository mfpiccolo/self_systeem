require "seeder_base"

class DefaultCategorySeeder < SeederBase

  def initialize(organization, names = Rails.configuration.default_category_names)
    super(target: organization, names: names)
  end

  def seed_record(name)
    DefaultCategory.create organization: target, name: name
  end

  def self.seed(organization, names = Rails.configuration.default_category_names)
    new(organization, names).seed
  end

end
