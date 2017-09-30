require 'ruby-graphviz'
require_relative 'erbal_t'

module Pgerd
  class Erd
    TABLE_TEMPLATE = <<-END_HTML
<table border="0" align="center" cellspacing="0" cellpadding="1">
  <tr><td align="center"><font face="Arial" point-size="10"><%= name %></font></td></tr>
  <tr><td height='4'></td></tr>
  <hr/>
  <tr><td height='6'></td></tr>
  <% if column_groups.any? %>
  <% column_groups.each_with_index do |group, index| %>
    <% if index > 0 %>
      <tr><td height='3'></td></tr>
    <% end %>
    <% group.each do |column| %>
      <tr><td align="left" port="<%= column.name %>"><%= column.name %> <font face="Arial Italic" color="grey60"><%= column.abbreviated_data_type %></font></td></tr>
    <% end %>
  <% end %>
</table>
<% end %>
END_HTML

    attr_reader :diagram

    def initialize(database, options = {})
      @database = database
      @title = options[:title] || @database.name
      @groups_to_hide = []
      @groups_to_hide << :id unless options.fetch(:show_id, true)
      @groups_to_hide << :timestamps unless options.fetch(:show_timestamps, true)

      create_a_digraph
      draw_the_tables
      draw_the_foreign_keys
    end

    def to_s
      @diagram.output(dot: String)
    end

    private

    def create_a_digraph
      @diagram = GraphViz.new(@title,
        type: :digraph,
        concentrate: true,
        nodesep: '0.4',
        rankdir: 'LR',
        ranksep: '0.5',
        pad: '0.4,0.4',
        margin: '0,0',
        labelloc: 't',
        fontsize: 13,
        fontname: 'Arial',
        label: @title + "\n\n")

      @diagram.node[:shape] = 'box'
      @diagram.node[:style] = 'rounded'
      @diagram.node[:fontsize] = 10
      @diagram.node[:fontname] = 'ArialMT'
      @diagram.node[:margin] = "0.07,0.05"
      @diagram.node[:penwidth] = "1.0"

      @diagram.edge[:fontname] = "ArialMT"
      @diagram.edge[:fontsize] = "7"
      @diagram.edge[:dir] = "both"
      @diagram.edge[:arrowsize] = "0.9"
      @diagram.edge[:penwidth] = "1.0"
      @diagram.edge[:labelangle] = "32"
      @diagram.edge[:labeldistance] = "1.8"
      @diagram.edge[:arrowtail] = "none"
    end

    def draw_the_tables
      @database.tables.each { |table| draw_table(table) }
    end

    def draw_table(table)
      grouped_columns = table.columns
        .reject { |column| @groups_to_hide.include? column.group }
        .group_by(&:group)
        .values

      html = ErbalT.new(name: table.name, column_groups: grouped_columns).render(TABLE_TEMPLATE).strip
      @diagram.add_node(table.name, label: "<#{html}>")
    end

    def draw_the_foreign_keys
      @database.foreign_keys.each { |fk| draw_foreign_key(fk) }
    end

    def draw_foreign_key(fk)
      from = address(fk.from_table, fk.from_column)
      to = address(fk.to_table, fk.to_column)

      @diagram.add_edge(from, to,  { :weight => 2 })
    end

    def address(table, column)
      return table if column == 'id'
      { table => column }
    end
  end
end
