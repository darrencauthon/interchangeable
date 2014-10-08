require "interchangeable/version"

class Class
  def interchangeable_instance_method *args, &block
    entry = Struct.new(:method_name, :target, :level, :implemented, :default)
                  .new(args[0], self, :instance, false, false)
    Interchangeable.entries << entry
    if block
      Interchangeable.define self, args[0], &block
      entry.default = true
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
      Interchangeable.entries.select { |x| x.target == the_class && x.method_name && method_name }.first.implemented = true
    end
  end

end
