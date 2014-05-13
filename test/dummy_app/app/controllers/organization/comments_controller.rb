class Organization::CommentsController < User::BaseController
  before_action :set_finish
  before_action :require_collaborator_access

  def new
    @comment = Comment.new
    render "shared/comments/form"
  end

  def create
    @comment = @finish.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to [@organization, @project, @finish],
        notice: "Comment successfully added."
    else
      render "shared/comments/form"
    end
  end

  def edit
    set_comment
    render "shared/comments/form"
  end

  def update
    set_comment

    if @comment.user != current_user
      flash[:error] = "You are not permitted to edit this comment."
      redirect_to [@organization, @project, @finish]
      return
    end

    if @comment.update_attributes(comment_params)
      redirect_to [@organization, @project, @finish],
        notice: "Comment successfully updated."
    else
      render "shared/comments/form"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_organization
    @organization ||= current_user.organizations.find params[:organization_id]
  end

  def set_project
    @project ||= set_organization.projects.find params[:project_id]
  end

  def set_finish
    @finish ||= set_project.finishes.find params[:finish_id]
  end

  def set_comment
    @comment ||= set_finish.comments.find params[:id]
  end

end
