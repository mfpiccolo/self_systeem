class ProjectCreator
  attr_reader :user
  attr_reader :project

  def initialize(user, name, location = nil, description = nil)
    @user = user
    @project = Project.new(
      name: name,
      location: location,
      description: description
    )
  end

  def create
    ActiveRecord::Base.transaction do
      if project.save
        ProjectUser.create(user: user, project: project, role: "owner")
        AreaSeeder.seed(project)
        CategorySeeder.seed(project)
      end
    end

    project
  end

  def self.create(user, name, location = nil, description = nil)
    new(user: user,
      name: name,
      location: location,
      description: description
    ).create
  end

end
