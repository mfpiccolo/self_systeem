class Organization::OrganizationsController < Organization::BaseController

  def new
    @organization = Organization.new
    render :new, layout: "user"
  end

  def create
    @organization = OrganizationCreator.create(
      user: current_user,
      name: organization_params[:name],
      location: organization_params[:location],
      description: organization_params[:description]
    )

    if @organization.persisted?
      redirect_to organization_path(@organization),
        notice: "Organization successfully created."
    else
      render :new, layout: "user"
    end
  end

  def show
    set_organization
    redirect_to organization_members_path(@organization)
  end

  def edit
    set_organization_categories_and_areas
  end

  def update
    set_organization_categories_and_areas

    if @organization.update_attributes organization_params
      redirect_to organization_path(@organization),
        notice: "Organization successfully created."
    else
      render :edit
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :location, :description, :logo)
  end

  def set_organization
    @organization ||= current_user.organizations.find params[:id]
  end

  def set_organization_categories_and_areas
    @categories ||= set_organization.categories
    @areas      ||= set_organization.areas
  end

end
