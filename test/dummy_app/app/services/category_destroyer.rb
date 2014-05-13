class CategoryDestroyer
  attr_reader :category

  def initialize(category:)
    @category = category
  end

  def destroy
    raise LastObjectInCollectionDeletionError if category.last_for_project?
    raise ObjectAssociatedToDependents        if category.have_dependents?

    category.destroy!
  end

  def self.destroy(category:)
    new(category: category).destroy
  end

end
