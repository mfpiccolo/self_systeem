class DefaultCategoryDestroyer
  attr_reader :category

  def initialize(category:)
    @category = category
  end

  def destroy
    if category.last_for_organization?
      raise LastObjectInCollectionDeletionError
    end

    category.destroy!
  end

  def self.destroy(category:)
    new(category: category).destroy
  end

end
