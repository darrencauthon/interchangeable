require_relative '../minitest_spec'

describe Interchangeable::Tables do

  describe "generate" do

    let(:methods) { [] }

    let(:table) do
      Interchangeable::Tables.generate methods
    end

    it "should return a table" do
      table.is_a?(Terminal::Table).must_equal true
    end

    describe "the header row" do
      it "should set column 0 to the class" do
        table.headings[0].value.must_equal "Class"
      end

      it "should set column 1 to the method" do
        table.headings[1].value.must_equal "Method"
      end

      it "should set column 2 to the method" do
        table.headings[2].value.must_equal "Description"
      end
    end

    describe "with methods" do

      let(:method_definition) { Struct.new(:target, :method_name, :description) }

      let(:methods) do
        [
          method_definition.new(Object.new, Object.new, Object.new),
          method_definition.new(Object.new, Object.new, Object.new),
        ]
      end

      it "should return two rows" do
        table.rows.count.must_equal 2
      end

      it "should map the target to the first column" do
        table.rows[0][0].value.must_be_same_as methods[0].target
        table.rows[1][0].value.must_be_same_as methods[1].target
      end

      it "should map the method name to the second column" do
        table.rows[0][1].value.must_be_same_as methods[0].method_name
        table.rows[1][1].value.must_be_same_as methods[1].method_name
      end

      it "should map the description to the third column" do
        table.rows[0][2].value.must_be_same_as methods[0].description
        table.rows[1][2].value.must_be_same_as methods[1].description
      end

    end

  end

end
