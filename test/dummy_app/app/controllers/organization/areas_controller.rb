class Organization::AreasController < Organization::BaseController

  def new
    set_project
    @area = Area.new
    render "shared/areas/form"
  end

  def create
    set_project
    @area = @project.areas.build(area_params)
    if @area.save
      redirect_to edit_organization_project_path(@organization, @project),
        notice: "Area successfully added."
    else
      render "shared/areas/form"
    end
  end

  def edit
    set_area
    render "shared/areas/form"
  end

  def update
    set_area
    if @area.update_attributes(area_params)
      redirect_to edit_organization_project_path(@organization, @project),
        notice: "Area successfully updated."
    else
      render "shared/areas/form"
    end
  end

  def destroy
    set_area
    begin
      AreaDestroyer.destroy(area: @area)
      flash[:notice] = "Area successfully removed."
    rescue LastObjectInCollectionDeletionError
      flash[:error] = "You must have at least one area associated to a project."
    rescue ObjectAssociatedToDependents
      flash[:error] = "Area not removed because it is associated to " +
        "one or more finishes."
    end

    redirect_to edit_organization_project_path(@organization, @project)
  end

  private

  def area_params
    params.require(:area).permit(:name)
  end

  def set_organization
    @organization ||= current_user.organizations.find params[:organization_id]
  end

  def set_project
    @project ||= set_organization.projects.find params[:project_id]
  end

  def set_area
    @area ||= set_project.areas.find params[:id]
  end

end
