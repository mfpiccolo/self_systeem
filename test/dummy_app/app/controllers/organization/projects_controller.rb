class Organization::ProjectsController < Organization::BaseController

  def index
    @projects = set_organization.projects.page(params[:page])
    render "shared/projects/index"
  end

  def new
    set_organization
    @project = Project.new
    render "shared/projects/new"
  end

  def create
    set_organization
    @project = OrganizationProjectCreator.create(
      organization: @organization, name: params[:project][:name]
    )

    if @project.persisted?
      redirect_to organization_project_finishes_path(@organization, @project),
        notice: "Project successfully created."
    else
      render "shared/projects/new"
    end
  end

  def show
    set_project
    redirect_to organization_project_finishes_path(@organization, @project)
  end

  def edit
    set_project_categories_and_areas
    render "shared/projects/edit"
  end

  def update
    set_organization
    set_project_categories_and_areas

    if @project.update_attributes project_params
      redirect_to organization_project_finishes_path(@organization, @project),
        notice: "Project successfully created."
    else
      render "shared/projects/edit"
    end
  end

  def destroy
    set_project
    if @project.destroy
      redirect_to organization_projects_path(@organization),
        notice: "Project successfully removed."
    else
      redirect_to organization_project_finishes_path(@organization, @project),
        error: "Unable to remove project."
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :location)
  end

  def set_organization
    @organization ||= current_user.organizations.find params[:organization_id]
  end

  def set_project
    @project ||= set_organization.projects.find params[:id]
  end

  def set_project_categories_and_areas
    @categories ||= set_project.categories
    @areas      ||= set_project.areas
  end

end
