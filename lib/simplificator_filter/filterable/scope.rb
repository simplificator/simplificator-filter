=begin

module Filterable
  module Scope
    def self.included(base)
      base.class_eval do
        # @return NamedScope (Rails 2) or Scope (Rails 3)
        def filter_by parameters
          if parameters
            @order = FilterParameters.new(self, parameters)
            parameters.inject(self.scoped({})) do |scope, parameter|
              key, value = parameter

              if (filter_condition = filter_definition[key.to_sym]) && (!value.blank? || filter_condition.include_blank?)
                scope = scope.send(filter_condition.scope_name, value)
              end

              scope
            end
          else
            scoped({})
          end
        end

      end
    end
  end
end
=end