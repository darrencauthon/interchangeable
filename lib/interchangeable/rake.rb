require 'rake'

namespace "interchangeable" do
  desc "show the missing methods"
  task "missing_methods" do
    Kernel.puts Interchangeable::Tables.generate(Interchangeable.missing_methods)
  end
end
