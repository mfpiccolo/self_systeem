class FinishDeselector
  attr_reader :finish
  attr_reader :project

  def initialize(finish:)
    @finish  = finish
    @project = finish.project
  end

  def deselect!
    ActiveRecord::Base.transaction do
      finish.deselect!
      project.set_selected_total_amount!
      true
    end
  end

  def self.deselect!(finish:)
    new(finish: finish).deselect!
  end

end
