module Filterable

  class FilterDefinition < ScopeLogic::Definition

    def method_missing name, *args, &block
      args = [{}] if args.empty?

      options = condition_options(name, args[0])
      self[name] =  if args[0][:class]
        args[0][:class].constantize.new(table, options)
      else
        FilterCondition.new(table, options)
      end
    end

  end

end
