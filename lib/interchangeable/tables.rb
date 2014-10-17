module Interchangeable
  module Tables
    def self.generate methods
      Terminal::Table.new(headings: ['Class', 'Method', 'Description'], style: { width: 80 } ) do |table|
        methods.each do |method|
          table << [method.target, method.method_name, method.description]
        end
      end
    end
  end
end
