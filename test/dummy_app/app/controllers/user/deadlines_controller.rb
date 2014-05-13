class User::DeadlinesController < User::BaseController
  before_action :set_project
  before_action :require_admin_access, only: [:create, :update, :destroy]

  def index
    @deadlines = @project.deadlines.page params[:page]
    render "shared/deadlines/index"
  end

  def new
    set_project_areas_and_categories
    @deadline = Deadline.new
    render "shared/deadlines/form"
  end

  def create
    set_project_areas_and_categories
    @deadline = @project.deadlines.build(deadline_params)
    if @deadline.save
      @deadline.set_completion_status!
      redirect_to [@project, @deadline], notice: "Deadline successfully added."
    else
      render "shared/deadlines/form"
    end
  end

  def show
    set_deadline
    @finishes = @deadline.finishes
    render "shared/deadlines/show"
  end

  def edit
    set_deadline
    set_project_areas_and_categories
    render "shared/deadlines/form"
  end

  def update
    set_deadline
    set_project_areas_and_categories
    if @deadline.update_attributes(deadline_params)
      @deadline.set_completion_status!
      redirect_to [@project, @deadline],
        notice: "Deadline successfully updated."
    else
      render "shared/deadlines/form"
    end
  end

  def destroy
    set_deadline
    @deadline.destroy
    redirect_to [@project, :deadlines],
      notice: "Deadline successfully removed."
  end

  private

  def deadline_params
    params.require(:deadline).permit(
      :due_date,
      :area_id,
      :category_id,
      :description
    )
  end

  def set_project
    @project ||= current_user.projects.find params[:project_id]
  end

  def set_deadline
    @deadline ||= set_project.deadlines.find params[:id]
  end

  def set_project_areas_and_categories
    @areas      ||= set_project.areas
    @categories ||= set_project.categories
  end

end
