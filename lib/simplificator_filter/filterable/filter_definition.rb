module Filterable

  class FilterDefinition < ScopeLogic::Definition

    def create_condition name, options
      condition_options = condition_options(name, options)
      if options[:class]
        options[:class].constantize.new(base_model, condition_options)
      else
        FilterCondition.new(base_model, condition_options)
      end
    end

  end

end
