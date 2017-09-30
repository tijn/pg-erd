module Pgerd
  class ForeignKey
    include Comparable
    attr_reader :from_table, :from_column, :to_table, :to_column

    def initialize(data)
      @from_table = data['from_table']
      @from_column = data['from_column']
      @to_table = data['to_table']
      @to_column = data['to_column']
    end

    def to_s
      "#{@from_table}.#{@from_column} --> #{@to_table}.#{@to_column}"
    end

    def <=>(other)
      to_a_for_sorting <=> other.to_a_for_sorting
    end

    def to_a_for_sorting
      [@from_table, @from_column, @to_table, @to_column]
    end
  end
end
