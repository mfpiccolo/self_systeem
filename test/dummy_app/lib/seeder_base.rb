class SeederBase
  attr_accessor :names
  attr_accessor :target

  def initialize(target: target, names: names)
    @target = target
    @names  = names
  end

  def seed
    names.map { |name| seed_record(name) }
  end

  def seed_record(name)
    raise NotImplementedError, "override seed_record in a child class"
  end

end
