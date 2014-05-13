class AreaDestroyer
  attr_reader :area

  def initialize(area:)
    @area = area
  end

  def destroy
    raise LastObjectInCollectionDeletionError if area.last_for_project?
    raise ObjectAssociatedToDependents        if area.have_dependents?

    area.destroy!
  end

  def self.destroy(area:)
    new(area: area).destroy
  end

end
