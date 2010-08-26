module Orderable

  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods

    def order(options = {})
      raise Exception, "order does not exists anymore use result_array.context[:filters]"
      #filter_definition.values.first.scope.context[:filter]
      #context[:filters]
      #FilterParameters.new(self, options)
    end

    def order_definition &block
      scope_definition :order, &block
    end

    def default_orders_for_all_attributes
      default_scopes_for_all_attributes :order
    end

    def default_orders_for_attributes *attributes
      default_scopes_for_attributes :order, *attributes
    end
    alias default_order_for_attribute default_orders_for_attributes

    def order_by parameters
      scoped_by :order_definition, parameters
    end

  end
end
