class UserProjectsCell < Cell::Rails
  helper ApplicationHelper

  def show(user:)
    @project_count = user.projects.count
    @projects = user.projects.limit(10)

    render
  end

end
