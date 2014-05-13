class User::BudgetItemsController < User::BaseController
  before_action :set_project
  before_action :require_admin_access, only: [:create, :update, :destroy]

  def index
    @budget_items = @project.budget_items.page params[:page]
    render "shared/budget_items/index"
  end

  def new
    set_project_categories_and_areas
    @budget_item = BudgetItem.new
    render "shared/budget_items/form"
  end

  def create
    set_project_categories_and_areas
    @budget_item = @project.budget_items.build(budget_item_params)

    if @budget_item.save
      @project.set_total_budget!
      redirect_to [@project, @budget_item],
        notice: "Budget item successfully added."
    else
      render "shared/budget_items/form"
    end
  end

  def show
    set_budget_item
    @finishes = @budget_item.finishes
    render "shared/budget_items/show"
  end

  def edit
    set_budget_item
    set_project_categories_and_areas
    render "shared/budget_items/form"
  end

  def update
    set_budget_item
    set_project_categories_and_areas
    if @budget_item.update_attributes(budget_item_params)
      @project.set_total_budget!
      redirect_to [@project, @budget_item],
        notice: "Budget item successfully updated."
    else
      render "shared/budget_items/form"
    end
  end

  def destroy
    set_budget_item
    @budget_item.destroy
    @project.set_total_budget!
    redirect_to project_budget_items_path(@project),
      notice: "Budget item successfully removed."
  end

  private

  def budget_item_params
    params.require(:budget_item).permit(
      :area_id,
      :category_id,
      :amount,
      :request_approver_id
    )
  end

  def set_project
    @project ||= current_user.projects.find params[:project_id]
  end

  def set_budget_item
    @budget_item ||= set_project.budget_items.find params[:id]
  end

  def set_project_categories_and_areas
    @categories ||= set_project.categories
    @areas      ||= set_project.areas
  end

end
