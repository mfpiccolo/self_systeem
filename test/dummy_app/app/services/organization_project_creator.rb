class OrganizationProjectCreator
  attr_reader :organization
  attr_reader :project

  def initialize(organization:, name:)
    @organization = organization
    @project      = Project.new name: name
  end

  def create
    ActiveRecord::Base.transaction do
      if project.save
        ProjectOrganization.create(organization: organization, project: project)
        AreaSeeder.seed project, organization.default_area_names
        CategorySeeder.seed project, organization.default_category_names
      end
    end

    project
  end

  def self.create(organization:, name:)
    new(organization: organization, name: name).create
  end

end
