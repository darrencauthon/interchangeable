require "interchangeable/version"

class Class

  def interchangeable_describe description
    @interchangeable_description = description
  end

  def interchangeable_instance_method *args, &block
    entry = Struct.new(:method_name, :target, :level, :implemented, :default, :description)
                  .new(args[0], self, :instance, false, false, @interchangeable_description)
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
      entry = Interchangeable.entries.select { |x| x.target == the_class && x.method_name && method_name }.first
      entry.implemented = true
      entry.default     = false
    end
  end

end
