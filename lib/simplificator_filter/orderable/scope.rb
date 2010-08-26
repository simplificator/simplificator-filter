=begin
module Orderable
  module Scope
    def self.included(base)
      base.class_eval do
        # @return NamedScope (Rails 2) or Scope (Rails 3)
        def order_by parameters
          if parameters
            @order = OrderParameters.new(self, parameters)
            scope = parameters.inject(self.scoped({})) do |scope, parameter|
              key, value = parameter

              if (order_condition = order_definition[key.to_sym]) && !value.blank?
                scope = scope.send(order_condition.scope_name, value)
              end

              scope
            end
            scope
          else
            scoped({})
          end
        end
      end
    end
  end
end
=end