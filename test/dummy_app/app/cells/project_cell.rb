class ProjectCell < Cell::Rails
  helper ApplicationHelper

  def show(project:)
    @project = project

    render
  end

end
