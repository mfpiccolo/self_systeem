class User::ProjectAttachmentsController < User::BaseController
  before_action :set_project
  before_action :require_member_access, only: [:destroy]

  def index
    @attachments = @project.attachments.page(params[:page])
    render "shared/project_attachments/index"
  end

  def create
    @attachment = @project.attachments.build(attachment_params)

    if @attachment.save
      flash[:notice] = "Attachment successfully added."
    else
      flash[:error] = "There was a problem creating the attachment."
    end

    if @attachment.finish
      redirect_to project_finish_path(@project, @attachment.finish)
    else
      redirect_to project_attachments_path(@project)
    end
  end

  def destroy
    attachment = @project.attachments.find params[:id]
    attachment.destroy
    flash[:notice] = "Attachment successfully removed."
    if attachment.finish
      redirect_to project_finish_path(@project, attachment.finish)
    else
      redirect_to project_attachments_path(@project)
    end
  end

  private

  def attachment_params
    params.require(:project_attachment).permit(:file, :finish_id)
  end

  def set_project
    @project ||= current_user.projects.find params[:project_id]
  end

end
