require_relative 'column'

module Pgerd
  class Table
    include Comparable
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def <=>(other)
      name <=> other.name
    end

    def columns
      CONNECTION
        .exec_params("select column_name, data_type from information_schema.columns where table_name='#{safe_name}'")
        .map { |record| Column.new(record['column_name'], record['data_type']) }
        .sort
    end

    def safe_name
      CONNECTION.escape_string(@name)
    end

    def to_s
      "#{name} [label = <>]"
    end
  end
end
