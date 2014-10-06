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
  end

end
