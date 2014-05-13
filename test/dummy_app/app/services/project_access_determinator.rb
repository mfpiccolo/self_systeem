class ProjectAccessDeterminator
  attr_reader :user
  attr_reader :project
  attr_reader :organization
  attr_reader :role

  def initialize(project: project, user: user, organization: nil)
    @user          = user
    @project       = project
    @organization  = organization
    @role          = determine_role
  end

  def access
    if organization
      organization_access_level
    else
      user_access_level
    end
  end

  def self.access(project: project, user: user, organization: nil)
    new(project: project, user: user, organization: organization).access
  end

  def determine_role
    @role = if organization
      organization.organization_users.find_by_user_id(user.id).try(:role)
    else
      project.project_users.find_by_user_id(user.id).try(:role)
    end
  end

  def organization_access_level
    role ? :admin : nil
  end

  def user_access_level
    if project.organizations.any?
      user_access_for_project_with_an_organization
    else
      user_access_for_project_without_an_organization
    end
  end

  def user_access_for_project_with_an_organization
    case role
    when "owner" then :member
    when "collaborator" then :collaborator
    else
      nil
    end
  end

  def user_access_for_project_without_an_organization
    case role
    when "owner" then :admin
    when "collaborator" then :collaborator
    else
      nil
    end
  end

end
