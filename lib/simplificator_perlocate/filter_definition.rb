module Filterable

  class FilterDefinition < Hash

    attr_reader :table

    def initialize table
      @table = table
    end

    def method_missing name, *args, &block
      args = [{}] if args.empty?

      if args[0][:association]
        self[name] = (args[0][:association]).to_s.singularize.capitalize.constantize.filter_definition[args[0][:filter].to_sym]
      else
        options = condition_options(name, args[0])
        self[name] =  if args[0][:class]
                        args[0][:class].constantize.new(table, options)
                      else
                        FilterCondition.new(table, options)
                      end
      end


    end

    def condition_options name, options
      options[:name]   = name
      options[:column] = (options[:column] || name).to_s
      column = table.columns_hash[options[:column]]

      #unless column
      #  raise ArgumentError, "unknown column '#{args[0][:column]}'"
      #end

      options[:table]     ||= table.table_name
      options[:column]      = column.name
      options[:column_type] = column.type

      options
    end

    def reference_filter

    end

  end

end