require 'rake'

namespace "interchangeable" do
  task "missing_methods" do
    Kernel.puts Interchangeable::Tables.generate(Interchangeable.missing_methods)
  end
end
