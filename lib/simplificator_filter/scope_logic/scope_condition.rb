module ScopeLogic

  class ScopeCondition
    attr_reader :scope_name, :scope, :column, :name, :attribute

    def initialize base_model, options
      @base_model         = base_model
      @parent_model       = options[:parent_model]
      @column             = options[:column]
      @name               = options[:name]
      @attribute          = options[:attribute]
      @scope              = scope(base_model)
      @path               = options[:attribute].split('.')[0...-1] # association path without attribute name
      @nested             = options[:nested]
    end

    protected

      def nested_column(strategy, value)
        if value
          replace_leaf_by(@nested, {column.to_sym.send(strategy) => value})
        else
          replace_leaf_by(@nested, column.to_sym.send(strategy))
        end
      end

      def replace_leaf_by(nested_hash, hash)
        if nested_hash.nil?
          hash
        elsif nested_hash.instance_of? Hash
          {nested_hash.first[0].to_sym => replace_leaf_by(nested_hash.first[1], hash)}
        else
          {nested_hash.to_sym => hash}
        end
      end
  end
end
