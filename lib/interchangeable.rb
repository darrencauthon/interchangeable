require 'terminal-table'
require "interchangeable/tables"
require "interchangeable/version"

class Class

  def interchangeable_describe description
    @interchangeable_description = description
  end

  def interchangeable_method *args, &block
    description = @interchangeable_description
    @interchangeable_description = nil
    entry = Struct.new(:method_name, :target, :implemented, :default, :description)
                  .new(args[0], self, false, false, description)
    Interchangeable.methods << entry
    if block
      Interchangeable.define self, args[0], &block
      entry.default = true
    end
  end
end

module Interchangeable

  class << self

    attr_accessor :methods
    def methods
      @settings ||= []
    end

    def missing_methods
      methods.reject { |m| m.implemented }
    end

    def define the_class, method_name, &block
      entry = Interchangeable.methods.select { |x| x.target == the_class && x.method_name && method_name }.first
      unless entry
        entry = Interchangeable.methods.select { |x| x.target == the_class.singleton_class && x.method_name && method_name }.first
      end
      entry.target.instance_eval do
        define_method method_name, &block
      end
      entry.implemented = true
      entry.default     = false
    end
  end

end
