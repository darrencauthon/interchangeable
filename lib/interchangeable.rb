require "interchangeable/version"

class Class
  def interchangeable_instance_method *args, &block
    Interchangeable.entries << Struct.new(:method_name, :target, :level)
                             .new(args[0], self, :instance)
    Interchangeable.define(self, args[0], &block) if block
  end
end

module Interchangeable

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
