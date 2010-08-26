module Filterable

  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods
    include ScopeLogic::ClassMethods

    def filter(options = {})
      raise Exception, "filter does not exists anymore use result_array.context[:filters]"
      #filter_definition.values.first.scope.context[:filter]
      #context[:filters]
      #FilterParameters.new(self, options)
    end

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
end
