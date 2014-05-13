class Organization::DefaultAreasController < Organization::BaseController

  def new
    set_organization
    @area = DefaultArea.new
    render :form
  end

  def create
    set_organization
    @area = @organization.areas.build(area_params)
    if @area.save
      redirect_to edit_organization_path(@organization),
        notice: "Area successfully added."
    else
      render :form
    end
  end

  def edit
    set_area
    render :form
  end

  def update
    set_area
    if @area.update_attributes(area_params)
      redirect_to edit_organization_path(@organization),
        notice: "Area successfully updated."
    else
      render :form
    end
  end

  def destroy
    set_area
    begin
      DefaultAreaDestroyer.destroy area: @area
      flash[:notice] = "Area successfully removed."
    rescue LastObjectInCollectionDeletionError
      flash[:error] = "You must have at least one default area."
    end

    redirect_to edit_organization_path(@organization)
  end

  private

  def area_params
    params.require(:default_area).permit(:name)
  end

  def set_organization
    @organization ||= current_user.organizations.find params[:organization_id]
  end

  def set_area
    @area ||= set_organization.areas.find params[:id]
  end

end
