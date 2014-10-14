require_relative '../minitest_spec'
require_relative '../../lib/interchangeable/rake'

describe "the rake tasks" do

  describe "undefined" do

    let(:task_name) { "interchangeable:undefined_methods" }

    it "should include a rake task for returning the undefined methods" do
      # this will throw if the method is not defined
      Rake::Task[task_name]
    end

    it "should output the table" do
      methods         = Object.new
      Interchangeable.stubs(:undefined_methods).returns methods

      expected_output = Object.new
      Interchangeable::Tables.stubs(:generate).with(methods).returns expected_output

      Kernel.expects(:puts).with expected_output

      Rake::Task[task_name].invoke
    end

  end

end
