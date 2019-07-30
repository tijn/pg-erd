require 'ruby-graphviz'
require_relative 'erd/table_node'

module Pgerd
  class Erd
    attr_reader :diagram

    def initialize(database, options = {})
      @database = database
      @title = options[:title] || @database.name
      @size = options[:size].to_s.downcase
      @options = options

      create_a_digraph
      draw_the_tables
      draw_the_foreign_keys
    end

    def to_s
      @diagram.output(dot: String)
    end

    def a4?
      @size == 'a4'
    end

    private

    def create_a_digraph
      @diagram = GraphViz.new(@title,
        center: 1,
        concentrate: true,
        fontname: 'Helvetica',
        fontsize: 13,
        label: @title + "\n\n",
        labelloc: 't',
        margin: 0,
        nodesep: -10.0,
        outputorder: 'nodesfirst',
        overlap: false,
        pad: '0.4,0.4',
        rankdir: 'LR',
        ranksep: '0.5',
        splines: true,
        type: :digraph,
          )

      if a4?
        diagram[:size] = '8.3,11.7!'
        diagram[:ratio] = 'compress'
      end

      @diagram.node[:fontname] = 'Helvetica'
      @diagram.node[:fontsize] = 10
      @diagram.node[:margin] = "0.07,0.05"
      @diagram.node[:penwidth] = "1.0"
      @diagram.node[:shape] = 'box'
      @diagram.node[:style] = 'rounded'

      @diagram.edge[:arrowsize] = "0.9"
      @diagram.edge[:arrowtail] = "none"
      @diagram.edge[:dir] = "both"
      @diagram.edge[:fontname] = "Helvetica"
      @diagram.edge[:fontsize] = "7"
      @diagram.edge[:labelangle] = "32"
      @diagram.edge[:labeldistance] = "1.8"
      @diagram.edge[:penwidth] = "1.0"
    end

    def draw_the_tables
      @database.tables.each { |table| draw_table(table) }
    end

    def draw_table(table)
      html = Erd::TableNode.render(table, @options)
      @diagram.add_node(table.name, label: "<#{html}>")
    end

    def draw_the_foreign_keys
      @database.foreign_keys.each { |fk| draw_foreign_key(fk) }
    end

    def draw_foreign_key(fk)
      from = address(fk.from_table, fk.from_column)
      to = address(fk.to_table, fk.to_column)

      @diagram.add_edge(from, to, weight: 2)
    end

    def address(table, column)
      return table if column == 'id'
      { table => column }
    end
  end
end
