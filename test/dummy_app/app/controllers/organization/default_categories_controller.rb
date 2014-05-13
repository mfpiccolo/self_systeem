class Organization::DefaultCategoriesController < Organization::BaseController

  def new
    set_organization
    @category = DefaultCategory.new
    render :form
  end

  def create
    set_organization
    @category = @organization.categories.build(category_params)
    if @category.save
      redirect_to edit_organization_path(@organization),
        notice: "Category successfully added."
    else
      render :form
    end
  end

  def edit
    set_category
    render :form
  end

  def update
    set_category
    if @category.update_attributes(category_params)
      redirect_to edit_organization_path(@organization),
        notice: "Category successfully updated."
    else
      render :form
    end
  end

  def destroy
    set_category
    begin
      DefaultCategoryDestroyer.destroy category: @category
      flash[:notice] = "Category successfully removed."
    rescue LastObjectInCollectionDeletionError
      flash[:error] = "You must have at least one default category."
    end

    redirect_to edit_organization_path(@organization)
  end

  private

  def category_params
    params.require(:default_category).permit(:name)
  end

  def set_organization
    @organization ||= current_user.organizations.find params[:organization_id]
  end

  def set_category
    @category ||= set_organization.categories.find params[:id]
  end

end
