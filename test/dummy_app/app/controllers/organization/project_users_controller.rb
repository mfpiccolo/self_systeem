class Organization::ProjectUsersController < Organization::BaseController

  def index
    set_project
    @project_users = @project.project_users.joins(:user).page(params[:page])
    render "shared/project_users/index"
  end

  def new
    set_project
    @member = ProjectMember.new
    render "shared/project_users/new"
  end

  def create
    set_project

    @member = ProjectMember.new(project_member_params)
    @member.project = @project

    if @member.save
      redirect_to [@organization, @project, :members],
        notice: "Member successfully added to project."
    else
      flash[:error] = "There was a problem adding member to project."
      render "shared/project_users/new"
    end
  end

  def edit
    set_project_user
    render "shared/project_users/edit"
  end

  def update
    set_project_user

    if @project_user.update_attributes(project_user_params)
      redirect_to [@organization, @project, :members],
        notice: "Project member successfully updated."
    else
      flash[:error] = "There was a problem updating project member."
      render "shared/project_users/edit"
    end
  end

  def destroy
    set_project_user
    if @project_user.user == current_user
      flash[:error] = "You cannot remove yourself from a project."
    else
      @project_user.destroy
      flash[:notice] = "Project member successfully removed."
    end

    redirect_to [@organization, @project, :members]
  end

  private

  def project_member_params
    params.require(:project_member).permit(
      :email,
      :name,
      :role
    )
  end

  def project_user_params
    params.require(:project_user).permit(:role)
  end

  def set_organization
    @organization ||= current_user.organizations.find params[:organization_id]
  end

  def set_project
    @project ||= set_organization.projects.find params[:project_id]
  end

  def set_project_user
    @project_user ||= set_project.project_users.find params[:id]
  end

end
