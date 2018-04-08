require_relative 'column'
require 'forwardable'

module Pgerd
  class Table
    extend Forwardable
    include Comparable
    attr_reader :name
    def_delegators :@database, :connection

    def initialize(database, name)
      @database = database
      @name = name
    end

    def <=>(other)
      name <=> other.name
    end

    def columns
      connection
        .exec_params("select column_name, data_type from information_schema.columns where table_name='#{safe_name}'")
        .map { |record| Column.new(record['column_name'], record['data_type']) }
        .sort
    end

    def safe_name
      connection.escape_string(@name)
    end

    def to_s
      "#{name} [label = <>]"
    end
  end
end
