class Organization::FinishesController < Organization::BaseController

  def index
    set_project_areas_and_categories

    @category_budget = if params[:category_id].present?
      @project.budget_for_category params[:category_id]
    else
      @project.total_budget
    end

    @finishes = @project.finishes.filter(
      area_id: params[:area_id], category_id: params[:category_id]
    )

    render "shared/finishes/index"
  end

  def new
    set_project_areas_and_categories
    @finish = Finish.new
    render "shared/finishes/form"
  end

  def create
    set_project_areas_and_categories
    @finish = @project.finishes.build(finish_params)
    if @finish.save
      redirect_to organization_project_finish_path(@organization, @project, @finish),
        notice: "Finish successfully added."
    else
      render "shared/finishes/form"
    end
  end

  def show
    set_finish
    @comments = @finish.comments.order(:created_at)
    render "shared/finishes/show"
  end

  def edit
    set_finish
    set_project_areas_and_categories
    render "shared/finishes/form"
  end

  def update
    set_finish
    set_project_areas_and_categories
    if @finish.update_attributes(finish_params)
      @project.set_selected_total_amount!
      redirect_to organization_project_finish_path(@organization, @project, @finish),
        notice: "Finish successfully updated."
    else
      render "shared/finishes/form"
    end
  end

  def destroy
    set_finish
    @finish.destroy
    @project.set_selected_total_amount!
    redirect_to organization_project_finishes_path(@organization, @project),
      notice: "Finish successfully removed."
  end

  def select
    set_finish
    FinishSelector.select!(finish: @finish, user: current_user)
    render "shared/finishes/select"
  end

  def deselect
    set_finish
    FinishDeselector.deselect!(finish: @finish)
    render "shared/finishes/select"
  end

  private

  def finish_params
    params.require(:finish).permit(
      :name,
      :project_id,
      :area_id,
      :category_id,
      :location,
      :model,
      :quantity,
      :price,
      :description,
      :selected
    )
  end

  def set_organization
    @organization ||= current_user.organizations.find params[:organization_id]
  end

  def set_project
    @project ||= set_organization.projects.find params[:project_id]
  end

  def set_finish
    @finish ||= set_project.finishes.find params[:id]
  end

  def set_project_areas_and_categories
    @areas      ||= set_project.areas
    @categories ||= set_project.categories
  end

end
