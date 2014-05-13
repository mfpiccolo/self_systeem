class Organization::ProjectAttachmentsController < Organization::BaseController

  def index
    set_project
    @attachments = @project.attachments.page(params[:page])
    render "shared/project_attachments/index"
  end

  def create
    set_project
    @attachment = @project.attachments.build(attachment_params)

    if @attachment.save
      flash[:notice] = "Attachment successfully added."
    else
      flash[:error] = "There was a problem creating the attachment."
    end

    if @attachment.finish
      redirect_to organization_project_finish_path(@organization, @project, @attachment.finish)
    else
      redirect_to organization_project_attachments_path(@organization, @project)
    end
  end

  def destroy
    set_project
    attachment = @project.attachments.find params[:id]
    attachment.destroy
    flash[:notice] = "Attachment successfully removed."
    if attachment.finish
      redirect_to organization_project_finish_path(@organization, @project, attachment.finish)
    else
      redirect_to organization_project_attachments_path(@organization, @project)
    end
  end

  private

  def attachment_params
    params.require(:project_attachment).permit(:file, :finish_id)
  end

  def set_organization
    @organization ||= current_user.organizations.find params[:organization_id]
  end

  def set_project
    @project ||= set_organization.projects.find params[:project_id]
  end

end
