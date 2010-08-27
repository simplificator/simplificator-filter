module ScopeLogic

  module ClassMethods

    # creates a new filter definition if a block is passed
    # if no block is passed it returns the filter definition object
    def scope_definition scope_strategy, &block
      definition_name  = "#{scope_strategy}_definition"  # 'filter_definition'
      definition_class = "#{scope_strategy.to_s.capitalize}able::#{scope_strategy.to_s.capitalize}Definition".constantize # Filterable::FilterDefinition

      if block_given?
        definition = instance_variable_get("@#{definition_name}") || instance_variable_set("@#{definition_name}", definition_class.new(self))
        definition.instance_eval(&block)
      else
        instance_variable_get("@#{definition_name}")
      end
    end

    def default_scopes_for_all_attributes scope_strategy
      send "default_#{scope_strategy.to_s.pluralize}_for_attributes", *self.column_names.reject {|c| c == self.primary_key.to_s }
    end

    def default_scopes_for_attributes scope_strategy, *attributes
      definition_name  = "#{scope_strategy}_definition"  # 'filter_definition'
      definition_class = "#{scope_strategy.to_s.capitalize}able::#{scope_strategy.to_s.capitalize}Definition".constantize # Filterable::FilterDefinition

      instance_variable_get("@#{definition_name}") || instance_variable_set("@#{definition_name}", definition_class.new(self))
      attributes.each do |attribute|
        instance_variable_get("@#{definition_name}").send(attribute)
      end
    end

    # @return NamedScope (Rails 2) or Scope (Rails 3)
    def scoped_by name, parameters
      if parameters
        parameters.inject(self.scoped({})) do |scope, parameter|
          key, value = parameter

          if (condition = send(name)[key.to_sym]) && (!value.blank? || condition.include_blank?)
            scope = scope.send(condition.scope_name, value)
          end

          scope
        end
      else
        scoped({})
      end
    end

  end
end