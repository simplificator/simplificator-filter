module Orderable

  extend ActiveSupport::Concern

  module ClassMethods
    include ScopeLogic::ClassMethods

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

  def sorts
    order_values.inject({}) do |list, order_value|
      if order_value.instance_of?(Hash)
        meta_where, attribute = meta_column_and_attribute_by_column_hash(order_value)
        if order_value.values.first.instance_of?(Squeel::Nodes::Order)
          list[find_order_name_by_attribute(attribute)] = (order_value.values.first.direction == -1) ? :desc : :asc
        else
          list[find_order_name_by_attribute(attribute)] = meta_where.method.to_sym
        end
      elsif order_value.instance_of?(Squeel::Nodes::Order)
        list[find_order_name_by_attribute(order_value.expr)] = (order_value.direction == -1) ? :desc : :asc
      end
      list
    end
  end

  private
    def find_order_name_by_attribute(attribute)
      @klass.order_definition.conditions.detect{ |condition|
        condition.attribute == attribute
      }.try(:name) || attribute.to_sym
    end
end
