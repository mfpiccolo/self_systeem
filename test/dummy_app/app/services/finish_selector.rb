class FinishSelector
  attr_reader :finish
  attr_reader :user
  attr_reader :project

  def initialize(user:, finish:)
    @user    = user
    @finish  = finish
    @project = finish.project
  end

  def select!
    ActiveRecord::Base.transaction do
      finish.select!(user)
      project.set_selected_total_amount!
      true
    end
  end

  def self.select!(user:, finish:)
    new(user: user, finish: finish).select!
  end

end
