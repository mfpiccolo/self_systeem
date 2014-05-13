class Organization::CategoriesController < Organization::BaseController

  def new
    set_project
    @category = Category.new
    render "shared/categories/form"
  end

  def create
    set_project
    @category = @project.categories.build(category_params)
    if @category.save
      redirect_to edit_organization_project_path(@organization, @project),
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
      redirect_to edit_organization_project_path(@organization, @project),
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

    redirect_to edit_organization_project_path(@organization, @project)
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_organization
    @organization ||= current_user.organizations.find params[:organization_id]
  end

  def set_project
    @project ||= set_organization.projects.find params[:project_id]
  end

  def set_category
    @category ||= set_project.categories.find params[:id]
  end

end
