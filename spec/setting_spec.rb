require_relative 'minitest_spec'

describe Setting do

  before do

    Setting.instance_eval { @settings = nil }

  end

  describe "defining a client specific method" do

    describe "defining a client-specific method on a class" do

      before do
        class Blah
          client_specific :something
        end
      end

      it "should create an entry in the settings" do
        Setting.settings.count.must_equal 1
      end

    end

  end


end
