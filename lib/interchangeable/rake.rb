require 'rake'

namespace "interchangeable" do
  task "undefined_methods" do
    Kernel.puts Interchangeable::Tables.generate(Interchangeable.undefined_methods)
  end
end
