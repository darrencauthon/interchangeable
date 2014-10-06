require_relative 'minitest_spec'

describe Setting do

  before do

    Setting.instance_eval { @settings = nil }

  end

  describe "defining a client specific method" do

    [
      ["Blah", "something"],
      ["Yawn", "applesauce"],
    ].map { |x| Struct.new(:class_name, :method_name).new(*x) }.each do |example|

      describe "noting a client-specific method on a class" do

        before do
          eval("class #{example.class_name}
                  client_specific :#{example.method_name}
                end")
        end

        it "should create an entry in the settings" do
          Setting.settings.count.must_equal 1
        end

        describe "defining the client-specific method" do

          let(:the_return_value) { Object.new }

          before do
            a = the_return_value
            Setting.define(eval(example.class_name), eval(":#{example.method_name}")) { a }
          end

          it "should stamp the method on the object" do
            instance = eval(example.class_name).new
            instance.send(example.method_name.to_sym).must_be_same_as the_return_value
          end

        end

        describe "accessing private members of the class" do

          before do
            Setting.define(eval(example.class_name), eval(":#{example.method_name}")) { @something }
          end

          it "should be able to access the private member" do
            instance = eval(example.class_name).new
            a = Object.new
            instance.instance_eval { @something = a }
            instance.send(example.method_name.to_sym).must_be_same_as a
          end
        end


      end

    end

  end


end
