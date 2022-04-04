require 'ruby-graphviz'
require 'ruby-progressbar'
require_relative 'erd/table_node'
require_relative 'erd/view_node'

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
      draw_the_views
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
        bgcolor: '#f4f8fa',
        center: 1,
        concentrate: true,
        fontcolor: '#000000d0',
        fontname: 'Helvetica',
        fontsize: 13,
        label: @title + "\n\n",
        labelloc: 't',
        # margin: 0,
        nodesep: 0.2,
        outputorder: 'nodesfirst',
        overlap: false,
        pad: '0.4,0.4',
        rankdir: 'LR',
        ranksep: '0.5',
        splines: true,
        type: :digraph)

      if a4?
        diagram[:size] = '8.3,11.7!'
        diagram[:ratio] = 'compress'
      end

      @diagram.node[:color] = '#000000d0'
      @diagram.node[:fillcolor] = '#ffffff'
      @diagram.node[:fontname] = 'Helvetica'
      @diagram.node[:fontsize] = 10
      # @diagram.node[:margin] = "0.07,0.05"
      @diagram.node[:margin] = "0"
      @diagram.node[:penwidth] = "1.0"
      @diagram.node[:shape] = 'box'
      @diagram.node[:style] = 'filled'

      @diagram.edge[:arrowsize] = "0.9"
      @diagram.edge[:arrowtail] = "none"
      @diagram.edge[:color] = '#000000d0'
      @diagram.edge[:dir] = "both"
      @diagram.edge[:fontname] = "Helvetica"
      @diagram.edge[:fontsize] = "7"
      @diagram.edge[:labelangle] = "32"
      @diagram.edge[:labeldistance] = "1.8"
      @diagram.edge[:penwidth] = "1.0"
    end

    def draw_the_tables
      progress = ProgressBar.create(
        title: 'Tables',
        total: @database.tables.count,
        format: '%t: |%B| %%%p %E',
	output: $stderr)
      @database.tables.each do |table|
        draw_table(table)
	progress.increment
      end
    end

    def draw_table(table)
      html = Erd::TableNode.render(table, @options)
      @diagram.add_node(table.name, label: "<#{html}>")
    end

    def draw_the_views
      progress = ProgressBar.create(
        title: 'Views',
        total: @database.tables.count,
        format: '%t: |%B| %%%p %E',
	output: $stderr)
      @database.views.each do |view|
        draw_view(view)
        progress.increment
      end
    end

    def draw_view(view)
      html = Erd::ViewNode.render(view, @options)
      @diagram.add_node(view.name, label: "<#{html}>")
    end

    def draw_the_foreign_keys
      progress = ProgressBar.create(
        title: 'Foreign Keys',
        total: @database.foreign_keys.count,
        format: '%t: |%B| %%%p %E',
	output: $stderr)
      @database.foreign_keys.each do |fk|
        draw_foreign_key(fk)
        progress.increment
      end
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
