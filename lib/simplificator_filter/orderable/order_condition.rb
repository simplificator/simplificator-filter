module Orderable

  class OrderCondition

    attr_reader :scope_name, :scope, :column

    def initialize base, options
      @column             = "#{ActiveRecord::Base.connection.quote_column_name(options[:table])}.#{ActiveRecord::Base.connection.quote_column_name(options[:column])}"
      @name               = options[:name]
      @scope_name         = "#{options[:name]}_order"
      @scope              = scope_rails_2(base)
      @path               = options[:attribute].split('.')[0...-1] # association path without attribute name
      @include_option     = options[:include]
    end

    protected

      def scope_rails_2 base
        base.named_scope @scope_name, lambda {|value|
          value = order_direction(value)
          scope = {:order => order_by(value)}
          scope[:include] = @include_option if @include_option
          scope[:context] = {:order => { @name.to_sym => value} }
          scope
        }
      end

      def scope_rails_3 base
        # TODO: add include_option
        base.scope @scope_name, lambda {|value|
          order order_by(value)
        }
      end

      def order_by value
        if value == :desc
          "#{@column} DESC"
        else
          "#{@column} ASC"
        end
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
