require "interchangeable/version"

class Class
  def interchangeable_instance_method *args, &block
    entry = Struct.new(:method_name, :target, :level, :implemented)
                  .new(args[0], self, :instance, false)
    Interchangeable.entries << entry
    if block
      Interchangeable.define(self, args[0], &block)
      entry.implemented = true
    end
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
