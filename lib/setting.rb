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

    def define _, _, &block
      Blah.instance_eval { define_method :something, &block }
    end
  end

end
