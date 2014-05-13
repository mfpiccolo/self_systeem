class DefaultAreaDestroyer
  attr_reader :area

  def initialize(area:)
    @area = area
  end

  def destroy
    if area.last_for_organization?
      raise LastObjectInCollectionDeletionError
    end

    area.destroy!
  end

  def self.destroy(area:)
    new(area: area).destroy
  end

end
