class Organization::OrganizationUsersController < Organization::BaseController
  before_filter :set_organization
  before_filter :require_organization_owner, except: :index

  def index
    @organization_users = @organization.organization_users.joins(:user).page(params[:page])
  end

  def new
    @member = OrganizationMember.new
  end

  def create
    @member = OrganizationMember.new(organization_member_params)
    @member.organization = @organization

    if @member.save
      redirect_to [@organization, :members],
        notice: "Member successfully added to organization."
    else
      flash[:error] = "There was a problem adding member to organization."
      render :new
    end
  end

  def edit
    set_organization_user
  end

  def update
    set_organization_user
    begin
      if @organization_user.update_attributes(organization_user_params)
        redirect_to [@organization, :members],
          notice: "Organization member successfully updated."
      else
        flash[:error] = "There was a problem updating organization member."
        render :edit
      end
    rescue OnlyOrganizationOwner
      flash[:error] = "You cannot change the only owner to #{organization_user_params[:role]}."
      render :edit
    end
  end

  def destroy
    set_organization_user
    if @organization_user.user == current_user
      flash[:error] = "You cannot remove yourself from a organization."
    else
      begin
        @organization_user.destroy
        flash[:notice] = "Organization member successfully removed."
      rescue OnlyOrganizationOwner
        flash[:error] = "You cannot remove the only owner from a organization."
      end
    end

    redirect_to [@organization, :members]
  end

  private

  def organization_member_params
    params.require(:organization_member).permit(
      :email,
      :name,
      :role
    )
  end

  def organization_user_params
    params.require(:organization_user).permit(:role)
  end

  def set_organization
    @organization ||= current_user.organizations.find params[:organization_id]
  end

  def set_organization_user
    @organization_user ||= set_organization.organization_users.find params[:id]
  end

end
