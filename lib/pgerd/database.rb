require_relative 'foreign_key'
require_relative 'table'

module Pgerd
  class Database
    attr_reader :name
    TABLES_TO_IGNORE = %w(ar_internal_metadata schema_migrations)

    def initialize(name)
      @name = name
    end

    def all_table_names
      connection
        .query("SELECT tablename FROM pg_catalog.pg_tables")
        .map { |table| table['tablename'] }
        .reject { |name| name.start_with?('pg_') || name.start_with?('sql_')}
    end

    def foreign_keys
      raw_foreign_keys.map { |data| ForeignKey.new(data) }
    end

    def raw_foreign_keys
      connection
        .query <<-END_SQL
            select c.constraint_name
                , x.table_schema as from_schema
                , x.table_name as from_table
                , x.column_name as from_column
                , y.table_schema as to_schema
                , y.table_name as to_table
                , y.column_name as to_column
            from information_schema.referential_constraints c
            join information_schema.key_column_usage x
                on x.constraint_name = c.constraint_name
            join information_schema.key_column_usage y
                on y.ordinal_position = x.position_in_unique_constraint
                and y.constraint_name = c.unique_constraint_name
            order by c.constraint_name, x.ordinal_position
          END_SQL
    end

    def table_names
      all_table_names - TABLES_TO_IGNORE
    end

    def tables
      table_names
        .map { |name| Table.new(self, name) }
        .sort_by { |table| table.foreign_keys.size }
        .reverse
    end

    def connection
      @connection ||= PG.connect(dbname: name, host: 'host.docker.internal', port: 5432, user: 'postgres')
    end
  end
end
