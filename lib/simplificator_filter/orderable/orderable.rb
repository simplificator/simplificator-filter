module Orderable

  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods

    def order(options = {})
      OrderParameters.new(self, options)
    end

    # creates a new filter definition if a block is passed
    # if no block is passed it returns the filter definition object
    def order_definition
      if block_given?
        yield @order_definition ||= OrderDefinition.new(self)
      else
        @order_definition
      end
    end

    def default_orders_for_all_attributes
      default_orders_for_attributes *self.column_names.reject {|c| c == self.primary_key.to_s }
    end

    def default_orders_for_attributes *attributes
      @order_definition ||= OrderDefinition.new(self)
      attributes.each do |attribute|
        @order_definition.send(attribute)
      end
    end
    alias default_order_for_attribute default_orders_for_attributes

    #TODO DRY this method
    # @return NamedScope (Rails 2) or Scope (Rails 3)
    def order_by parameters
      if parameters
        @order = OrderParameters.new(self, parameters)
        parameters.inject(self.scoped({})) do |scope, parameter|
          key, value = parameter

          if (order_condition = order_definition[key.to_sym]) && !value.blank?
            scope = scope.send(order_condition.scope_name, value)
          end

          scope
        end
      else
        scoped({})
      end
    end
  end
end
