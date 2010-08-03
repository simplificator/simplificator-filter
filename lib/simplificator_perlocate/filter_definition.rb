module Filterable

  class FilterDefinition < Hash

    attr_reader :table

    def initialize table
      @table = table
    end

    def method_missing name, *args, &block
      args = [{}] if args.empty?

      options = condition_options(name, args[0])
      self[name] =  if args[0][:class]
        args[0][:class].constantize.new(table, options)
      else
        FilterCondition.new(table, options)
      end
    end

    def condition_options name, options
      options[:name]   = name
      options[:attribute] = (options[:attribute] || name).to_s

      path = options[:attribute].split('.')
      base = table
      while path.length > 1
        part = path.delete_at(0)
        base = base.reflect_on_association(part.to_sym).class_name.constantize
      end

      column = base.columns_hash[path.first]

      unless column
        raise ArgumentError, "unknown attribute '#{path.first}' for #{base.name}"
      end

      options[:table]          = base.table_name
      options[:attribute]      = column.name
      options[:attribute_type] = column.type

      options
    end

    def reference_filter

    end

  end

end
