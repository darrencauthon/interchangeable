module Interchangeable
  module Tables
    def self.generate methods
      Terminal::Table.new(headings: ['Class', 'Method', 'Description']) do |table|
        methods.each do |method|
          table << [method.target, method.method_name, method.description]
        end
      end
    end
  end
end
