require_relative '../minitest_spec'
require_relative '../../lib/interchangeable/rake'

describe "the rake tasks" do

  it "should create a rake task" do
    raise Rake.application.tasks.inspect
  end

  it "should blah" do
   result = Rake::Task["ok"].invoke
   raise result.inspect
  end

end
