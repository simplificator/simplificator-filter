module ScopeLogic

  class Definition < Hash

    attr_reader :base_model, :conditions

    def initialize base_model
      @base_model = base_model
      @conditions = []
    end

    def [] name
      if condition = super
        if condition.instance_of? Hash
          condition = self[name] = create_condition(name, condition)
        end
      end
      @conditions << condition
      condition
    end

    def method_missing name, *args, &block
      args = [{}] if args.empty?

      self[name] = args[0] # lazy creation see def []
      #self[name] = create_condition(name, args[0]) # eager creation, creates a conflict with device_for in routes.rb
    end

    def create_condition name, options
      raise Exception, "overwrite in subclass"
    end

    def condition_options name, options
      options[:name]   = name
      options[:attribute] = (options[:attribute] || name).to_s
      path_with_attribute = options[:attribute].split('.')
      path_without_attribute = path_with_attribute[0...-1]

      column, parent_model = find_column_and_parent_model(path_with_attribute, base_model)

      unless column
        raise ArgumentError, "Can not resolve path #{options[:attribute]} on #{base.class.name}"
      end
      options[:parent_model]    = parent_model
      options[:column]          = column.name
      options[:attribute_type]  = column.type
      options[:nested]          = build_nested_hash(path_without_attribute, {})

      options
    end

    private
    # Walk a attribute path and find the attribute holding model and the name of the attribute
    # "customer.orders.items.price" => ["price", Item] (Item has attribute price)
    def find_column_and_parent_model(path, base_model)
      if path.length > 1
        find_column_and_parent_model(path[1..-1], base_model.reflect_on_association(path.first.to_sym).class_name.constantize)
      else
        [base_model.columns_hash[path.first.to_s], base_model]
      end
    end

    # "customer.orders.items" =>  :customer => {:orders => :items}
    def build_nested_hash(path, hash)
      if path.length > 1
        hash[path.first.to_sym] = build_nested_hash(path[1..-1], {})
        hash
      else
        path.first.try(:to_sym)
      end
    end

  end

end
