class User::AreasController < User::BaseController
  before_action :set_project
  before_action :require_admin_access

  def new
    @area = Area.new
    render "shared/areas/form"
  end

  def create
    @area = @project.areas.build(area_params)
    if @area.save
      redirect_to edit_project_path(@project),
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
      redirect_to edit_project_path(@project),
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

    redirect_to edit_project_path(@project)
  end

  private

  def area_params
    params.require(:area).permit(:name)
  end

  def set_project
    @project ||= current_user.projects.find params[:project_id]
  end

  def set_area
    @area ||= set_project.areas.find params[:id]
  end

end
