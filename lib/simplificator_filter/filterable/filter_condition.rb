module Filterable

  class FilterCondition < ScopeLogic::ScopeCondition

    @@default_strategy = {:string   => { :patterns => [:like, :begins_with, :ends_with], :default => :like },
                          :text     => { :patterns => [:like, :begins_with, :ends_with], :default => :like },
                          :integer  => { :patterns => [:equal, :between], :default => :equal },
                          :float    => { :patterns => [:equal, :between], :default => :equal },
                          :time     => { :patterns => [:equal, :between], :default => :equal },
                          :date     => { :patterns => [:equal, :between], :default => :equal },
                          :datetime => { :patterns => [:equal, :between], :default => :equal },
                          :binary   => { :patterns => [:equal], :default => :equal },
                          :boolean  => { :patterns => [:equal], :default => :equal }
                          }


    @@patterns = {:like         => /^\*(.*?)\*$/,
                  :ends_with    => /^\*(.*?)$/,
                  :begins_with  => /^(.*?)\*$/,
                  :between      => /^(-?\d+)\s?-\s?(-?\d+)$/
                  }

    def initialize base_model, options
      raise ArgumentError, "no default strategy defined for '#{options[:attribute_type]}'" unless @@default_strategy[options[:attribute_type]]
      @scope_name         = "#{options[:name]}_filter"
      @strategy           = options[:strategy] || @@default_strategy[options[:attribute_type]][:patterns]
      @default_strategy   = options[:strategy] || @@default_strategy[options[:attribute_type]][:default]
      @include_blank      = options[:include_blank] || false
      super
    end

    def include_blank?
      @include_blank
    end


    protected

      def scope base_model
        base_model.scope @scope_name, lambda {|value|
          s = base_model.where(condition(value))
          s = s.joins(@nested) if @nested
          s
        }
      end

      def condition value
        if @strategy.instance_of? Array
          strategy, value = parse(value)
          raise ArgumentError, "strategy #{strategy} not allowed for value '#{value}'" unless @strategy.include? strategy
        else
          strategy = @strategy
        end
        send(strategy, value)
      end

      def parse value
        case value
          when @@patterns[:like]
            [:like, $1]
          when @@patterns[:begins_with]
            [:begins_with, $1]
          when @@patterns[:ends_with]
            [:ends_with, $1]
          when @@patterns[:between]
            [:between, value]
          else
            [@default_strategy, value]
        end
      end

      def begins_with value
        nested_column('matches',"#{value}%")
      end

      def ends_with value
        nested_column('matches',"%#{value}")
      end

      def like value
        nested_column('matches',"%#{value}%")
      end

      def between value
        matchdata = @@patterns[:between].match(value)
        nested_column('in', (matchdata[1]..matchdata[2]))
      end

      def equal value
        nested_column('eq', value)
      end
  end

end
