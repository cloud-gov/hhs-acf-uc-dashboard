require 'csv'

module Import
  class FromCSV
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def call
      CSV.parse(content) do |row|
        next if row.first.match(/date/i)
        Row.new(row).call
      end
    end

    private

    def content
      File.read(path)
    end
  end
end
