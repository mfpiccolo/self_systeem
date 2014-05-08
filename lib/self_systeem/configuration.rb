module SelfSysteem
  module Configure
    attr_accessor :test_dir, :test_framework

    def configure
      yield self if block_given?
    end

    def test_dir
      self.instance_variable_get(:@test_dir) || "test"
    end

    def test_framework
      self.instance_variable_get(:@test_framework) || "minitest"
    end

  end
end
