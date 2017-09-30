module Pgerd
  class Column
    include Comparable
    attr_accessor :name, :data_type
    ID = %w(id)
    GROUPS = %i(id other timestamps)

    def initialize(name, data_type)
      @name = name
      @data_type = data_type
    end

    def <=>(other)
      to_a_for_sorting <=> other.to_a_for_sorting
    end

    def group
      if ID.include? @name
        :id
      elsif @data_type.include?("timestamp")
        :timestamps
      else
        :other
      end
    end

    def group_for_sorting
      GROUPS.index(group)
    end

    def abbreviated_data_type
      # The SQL standard requires that writing just timestamp be equivalent to timestamp without time zone,
      # and PostgreSQL honors that behavior.
      @data_type
        .gsub('timestamp without time zone', 'timestamp')
        .gsub(/\bwithout\b/, 'w/o')
        .gsub(/\bwith\b/, 'w/')
    end

    def to_s
      "#{name} [label = <>]"
    end

    def to_a_for_sorting
      [group_for_sorting, name, data_type]
    end
  end
end
