class User::CategoriesController < User::BaseController
  before_action :set_project
  before_action :require_admin_access

  def new
    @category = Category.new
    render "shared/categories/form"
  end

  def create
    @category = @project.categories.build(category_params)
    if @category.save
      redirect_to edit_project_path(@project),
        notice: "Category successfully added."
    else
      render "shared/categories/form"
    end
  end

  def edit
    set_category
    render "shared/categories/form"
  end

  def update
    set_category
    if @category.update_attributes(category_params)
      redirect_to edit_project_path(@project),
        notice: "Category successfully updated."
    else
      render "shared/categories/form"
    end
  end

  def destroy
    set_category
    begin
      CategoryDestroyer.destroy(category: @category)
      flash[:notice] = "Category successfully removed."
    rescue LastObjectInCollectionDeletionError
      flash[:error] = "You must have at least one category associated to a " +
        "project."
    rescue ObjectAssociatedToDependents
      flash[:error] = "Category not removed because it is associated to " +
        "one or more finishes."
    end

    redirect_to edit_project_path(@project)
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_project
    @project ||= current_user.projects.find params[:project_id]
  end

  def set_category
    @category ||= set_project.categories.find params[:id]
  end

end
