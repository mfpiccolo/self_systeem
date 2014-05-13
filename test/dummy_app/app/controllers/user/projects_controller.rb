class User::ProjectsController < User::BaseController
  before_action :set_project, only: [:show, :update, :destroy]
  before_action :require_admin_access, only: [:update, :destroy]

  def index
    @projects = current_user.projects#.page(params[:page])
    render "shared/projects/index"
  end

  def new
    @project = Project.new
    render "shared/projects/new"
  end

  def create
    @project = ProjectCreator.create(
      current_user, project_params[:name],
      project_params[:location],
      project_params[:description]
    )

    if @project.persisted?
      redirect_to project_finishes_path(@project),
        notice: "Project successfully created."
    else
      render "shared/projects/new"
    end
  end

  def show
    redirect_to project_finishes_path(@project)
  end

  def edit
    set_project_categories_and_areas
    render "shared/projects/edit"
  end

  def update
    set_project_categories_and_areas
    if @project.update_attributes project_params
      redirect_to project_finishes_path(@project),
        notice: "Project successfully created."
    else
      render "shared/projects/edit"
    end
  end

  def destroy
    if @project.destroy
      redirect_to projects_path, notice: "Project successfully removed."
    else
      redirect_to project_finishes_path(@project),
        alert: "Unable to remove project."
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :location, :description)
  end

  def set_project
    @project ||= current_user.projects.find params[:id]
  end

  def set_project_categories_and_areas
    @categories ||= set_project.categories
    @areas      ||= set_project.areas
  end

end
