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

  end

end
