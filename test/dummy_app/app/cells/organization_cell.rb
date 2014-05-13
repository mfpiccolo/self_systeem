class OrganizationCell < Cell::Rails
  helper ApplicationHelper

  def show(organization:)
    @organization = organization

    render
  end

end
