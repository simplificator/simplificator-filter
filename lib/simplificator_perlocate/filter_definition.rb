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

      base, column = walk_attribute_path(options[:attribute])

      unless column
        raise ArgumentError, "Can not resolve path #{options[:attribute]} on #{base.class.name}"
      end

      options[:table]          = base.table_name
      options[:attribute]      = column.name
      options[:attribute_type] = column.type

      options
    end

    def reference_filter

    end

    private
    # Walk a attribute path and find the base model and the name of the attribute
    # "orders.items.price" => [Item, "price"]
    def walk_attribute_path(attribute)
      path = attribute.split('.')
      base = table
      while path.length > 1
        part = path.delete_at(0)
        base = base.reflect_on_association(part.to_sym).class_name.constantize
      end
      [base, base.columns_hash[path.first.to_s]]
    end

  end

end
