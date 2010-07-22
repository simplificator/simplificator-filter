module Filterable

  class FilterDefinition < Hash

    attr_reader :table

    def initialize table
      @table = table
    end

    def method_missing name, *args, &block
      args[0][:name]   = name
      args[0][:column] = (args[0][:column] || name).to_s
      column = table.columns_hash[args[0][:column]]
      raise ArgumentError, "unknown column '#{args[0][:column]}'" unless column
      args[0][:table]     ||= table.table_name
      args[0][:column]      = column.name
      args[0][:column_type] = column.type


      self[name] =  if args[0][:class]
                      args[0][:class].constantize.new(table, args[0])
                    else
                      FilterCondition.new(table, args[0])
                    end
    end

  end

end