module Orderable

  class OrderDefinition < Hash

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
        OrderCondition.new(table, options)
      end
    end

    def condition_options name, options
      options[:name]   = name
      options[:attribute] = (options[:attribute] || name).to_s
      path_with_attribute = options[:attribute].split('.')
      path_without_attribute = path_with_attribute[0...-1]

      column, base = find_column_and_table(path_with_attribute, table)

      unless column
        raise ArgumentError, "Can not resolve path #{options[:attribute]} on #{base.class.name}"
      end

      options[:table]           = base.table_name
      options[:column]          = column.name
      options[:attribute_type]  = column.type
      options[:include]         = build_include_option(path_without_attribute, {})

      options
    end

    private
    # Walk a attribute path and find the base model and the name of the attribute
    # "customer.orders.items.price" => [Item, "price"]
    def find_column_and_table(path, base)
      if path.length > 1
        find_column_and_table(path[1..-1], base.reflect_on_association(path.first.to_sym).class_name.constantize)
      else
        [base.columns_hash[path.first.to_s], base]
      end
    end

    # "customer.orders.items" =>  :customer => {:orders => :items}
    def build_include_option(path, hash)
      if path.length > 1
        hash[path.first] = build_include_option(path[1..-1], {})
        hash
      else
        path.first
      end
    end

  end

end
