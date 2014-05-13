class OrganizationProjectsCell < Cell::Rails
  helper ApplicationHelper

  def show(organization:)
    @organization = organization
    @project_count = organization.projects.count
    @projects = organization.projects.limit(10)

    render
  end

end
