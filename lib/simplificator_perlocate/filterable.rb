module Filterable

  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods

    def filter
      @filter ||= FilterParameters.new(self)
    end

    # creates a new filter definition if a block is passed
    # if no block is passed it returns the filter definition object
    def filter_definition
      if block_given?
        yield @filter_definition ||= FilterDefinition.new(self)
      else
        @filter_definition
      end
    end

    def default_filters_for_all_attributes
      default_filters_for_attributes *self.column_names.reject {|c| c == self.primary_key.to_s }
    end

    def default_filters_for_attributes *attributes
      @filter_definition ||= FilterDefinition.new(self)
      attributes.each do |attribute|
        @filter_definition.send(attribute)
      end
    end
    alias default_filter_for_attribute default_filters_for_attributes


    # @return NamedScope (Rails 2) or Scope (Rails 3)
    def filter_by parameters
      @filter = FilterParameters.new(self, parameters)
      parameters.inject(nil) do |scope, parameter|
        key, value = parameter
        if filter_condition = filter_definition[key]
          (scope || self).send(filter_condition.name, value)
        end
      end
    end

  end

end