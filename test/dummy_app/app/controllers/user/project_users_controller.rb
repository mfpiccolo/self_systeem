class User::ProjectUsersController < User::BaseController
  before_action :set_project
  before_action :require_member_access, only: [:create, :update, :destroy]

  def index
    @project_users = @project.project_users.joins(:user).page(params[:page])
    render "shared/project_users/index"
  end

  def new
    @member = ProjectMember.new
    render "shared/project_users/new"
  end

  def create
    @member = ProjectMember.new(project_member_params)
    @member.project = @project

    if @member.save
      redirect_to project_members_path(@project),
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
    begin
      if @project_user.update_attributes(project_user_params)
        redirect_to project_members_path(@project),
          notice: "Project member successfully updated."
      else
        flash[:error] = "There was a problem updating project member."
        render "shared/project_users/edit"
      end
    rescue OnlyProjectOwner
      flash[:error] = "You cannot change the only owner to #{project_user_params[:role]}."
      render "shared/project_users/edit"
    end
  end

  def destroy
    set_project_user
    if @project_user.user == current_user
      flash[:error] = "You cannot remove yourself from a project."
    else
      begin
      @project_user.destroy
      flash[:notice] = "Project member successfully removed."
      rescue OnlyProjectOwner
        flash[:error] = "You cannot remove the only owner from a project."
      end
    end

    redirect_to project_members_path(@project)
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

  def set_project
    @project ||= current_user.projects.find(params[:project_id])
  end

  def set_project_user
    @project_user ||= set_project.project_users.find params[:id]
  end

end
