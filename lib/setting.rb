require "setting/version"

class Class
  def client_specific *args
  end
end

module Setting

  class << self
    def settings
      [Object.new]
    end

    def define the_class, method_name, &block
      the_class.instance_eval do
        define_method method_name, &block
      end
    end
  end

end
