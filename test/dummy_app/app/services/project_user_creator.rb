class ProjectUserCreator
  attr_reader :project_user

  def initialize(project:, user:, role:)
    @project_user = ProjectUser.new(project: project, user: user, role: role)
  end

  def create
    if project_user.save
      ProjectMailer.share(
        project_user.user_id, project_user.project_id
      ).deliver
    end

    project_user
  end

  def self.create(project:, user:, role:)
    new(project: project, user: user, role: role).create
  end

end
