module Filterable

  extend ActiveSupport::Concern

  module ClassMethods
    include ScopeLogic::ClassMethods

    def filter_definition &block
      scope_definition :filter, &block
    end

    def default_filters_for_all_attributes
      default_scopes_for_all_attributes :filter
    end

    def default_filters_for_attributes *attributes
      default_scopes_for_attributes :filter, *attributes
    end
    alias default_filter_for_attribute default_filters_for_attributes

    def filter_by parameters
      scoped_by :filter_definition, parameters
    end
  end

  def filters
    where_values.inject({}) do |list, where_value|
      if where_value.instance_of?(Hash)
        meta_where, value, attribute = meta_column_and_attribute_by_value_set(where_value)
        if meta_where
          list[find_filter_name_by_attribute(attribute)] = {meta_where.method_name => value}
        end
      end
      list
    end
  end

  def filter attribute
    pp where_values
  end

  private
    def find_filter_name_by_attribute(attribute)
      @klass.filter_definition.conditions.detect{ |condition|
        condition.attribute == attribute
      }.try(:name)
    end
end
