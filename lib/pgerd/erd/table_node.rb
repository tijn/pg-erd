require_relative '../erbal_t'

module Pgerd
  class Erd
    class TableNode
      TABLE_TEMPLATE = <<-END_HTML
<table border="0" align="center" cellspacing="0" cellpadding="1">
  <tr><td align="center"><font point-size="10"><%= name %></font></td></tr>
  <tr><td height='4'></td></tr>
  <hr/>
  <tr><td height='6'></td></tr>
  <% grouped_columns.each_with_index do |group, index| %>
    <% if index > 0 %>
      <tr><td height='3'></td></tr>
    <% end %>
    <% group.each do |column| %>
      <tr><td align="left" port="<%= column.name %>"><%= column.name %> <font color="grey60"><i><%= column.abbreviated_data_type %></i></font></td></tr>
    <% end %>
  <% end %>
</table>
END_HTML

      attr_reader :table, :groups_to_hide

      def initialize(table, options = {})
        @table = table

        @groups_to_hide = []
        @groups_to_hide << :id unless options.fetch(:show_id, true)
        @groups_to_hide << :timestamps unless options.fetch(:show_timestamps, true)
      end

      def self.render(table, options = {})
        new(table, options).to_html
      end

      def to_html
        grouped_columns = @table.columns
          .reject { |column| @groups_to_hide.include? column.group }
          .group_by(&:group)
          .values

        ErbalT.new(name: @table.name, grouped_columns: grouped_columns).render(TABLE_TEMPLATE).strip
      end
    end
  end
end
