class ProjectCreator
  attr_reader :user
  attr_reader :project

  def initialize(user, name = nil, location = nil, description = nil)
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

  def self.create(user, name = nil, location = nil, description = nil)
    new(user,
      name,
      location,
      description
    ).create
  end

end
