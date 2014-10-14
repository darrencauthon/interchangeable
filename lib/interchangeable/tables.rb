module Interchangeable
  module Tables
    def self.generate methods
      Terminal::Table.new(headings: ['Class', 'Method', 'Description'])
    end
  end
end
