require "setting/version"

class Class
  def instance_method *args, &block
    Setting.entries << Struct.new(:method_name, :target, :level)
                             .new(args[0], self, :instance)
    Setting.define(self, args[0], &block) if block
  end
end

module Setting

  class << self

    attr_accessor :entries
    def entries
      @settings ||= []
    end

    def define the_class, method_name, &block
      the_class.instance_eval do
        define_method method_name, &block
      end
    end
  end

end
