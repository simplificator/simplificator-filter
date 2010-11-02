module Orderable

  class OrderCondition < ScopeLogic::ScopeCondition

    def initialize base_model, options
      @scope_name = "#{options[:name]}_order"
      super
    end

    protected

      def scope base_model
        base_model.scope @scope_name, lambda {|value|
          s = base_model.order(order_by(value))
          s = s.joins(@nested) if @nested
          s
        }
      end

      def order_by value
        nested_column(order_direction(value), nil)
      end

      def order_direction(value)
        if value =~ /^desc$/
          :desc
        else
          :asc
        end
      end
  end
end
