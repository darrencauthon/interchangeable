require_relative 'minitest_spec'

describe Interchangeable do

  before do
    Interchangeable.instance_eval { @settings = nil }
  end

  describe "defining an instance-level method on a class" do

    [
      ["Blah", "something"],
      ["Yawn", "applesauce"],
    ].map { |x| Struct.new(:class_name, :method_name).new(*x) }.each do |example|

      describe "noting the method on a class" do

        before do
          eval("class #{example.class_name}
                  interchangeable_instance_method :#{example.method_name}
                end")
        end

        describe "entries" do

          it "should create an entry" do
            Interchangeable.entries.count.must_equal 1
          end

          it "should include the method name" do
            Interchangeable.entries.first.method_name.must_equal example.method_name.to_sym
          end

          it "should return the target" do
            Interchangeable.entries.first.target.must_equal eval(example.class_name)
          end

          it "should say that its an instance method" do
            Interchangeable.entries.first.level.must_equal :instance
          end

          it "should say that it is not implemented" do
            Interchangeable.entries.first.implemented.must_equal false
          end

        end

        describe "defining the method later" do

          let(:the_return_value) { Object.new }

          before do
            object = the_return_value
            Interchangeable.define(eval(example.class_name), eval(":#{example.method_name}")) { object }
          end

          it "should stamp the method on the object" do
            instance = eval(example.class_name).new
            instance.send(example.method_name.to_sym).must_be_same_as the_return_value
          end

          it "should say that it is not implemented" do
            Interchangeable.entries.first.implemented.must_equal true
          end

        end

        describe "accessing private members of the class" do

          before { Interchangeable.define(eval(example.class_name), eval(":#{example.method_name}")) { @something } }

          it "should be able to access the private member" do
            object = Object.new

            instance = eval(example.class_name).new
            instance.instance_eval { @something = object }
            instance.send(example.method_name.to_sym).must_be_same_as object
          end

        end

        describe "defining the client-specific method, but with arguments" do

          let(:apple)  { Object.new }
          let(:orange) { Object.new }

          before do
            Interchangeable.define(eval(example.class_name), eval(":#{example.method_name}")) do |a, b|
              [a, b]
            end
          end

          it "should allow me to call the method with arguments" do
            instance = eval(example.class_name).new

            result = instance.send(example.method_name.to_sym, apple, orange)
            result.must_equal [apple, orange]
          end

        end

      end

      describe "noting the method on a class with a default implementation" do

        ['potato', 'tomato'].each do |default_value|

          describe "multiple examples" do

            before do
              eval("class #{example.class_name}
                      interchangeable_instance_method(:#{example.method_name}) { \"#{default_value}\" }
                    end")
            end

            it "should return the default value if called" do
              instance = eval(example.class_name).new

              result = instance.send(example.method_name.to_sym)
              result.must_equal default_value
            end

            it "should say that it is not implemented" do
              Interchangeable.entries.first.implemented.must_equal true
            end

          end

        end

      end

    end

  end

end
