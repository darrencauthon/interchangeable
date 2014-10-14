require_relative '../minitest_spec'
require_relative '../../lib/interchangeable/rake'

describe "the rake tasks" do

  describe "missing" do

    let(:task_name) { "interchangeable:missing_methods" }

    it "should include a rake task for returning the missing methods" do
      # this will throw if the method is not defined
      Rake::Task[task_name]
    end

    it "should output the table" do
      methods         = Object.new
      Interchangeable.stubs(:missing_methods).returns methods

      expected_output = Object.new
      Interchangeable::Tables.stubs(:generate).with(methods).returns expected_output

      Kernel.expects(:puts).with expected_output

      Rake::Task[task_name].invoke
    end

  end

end
