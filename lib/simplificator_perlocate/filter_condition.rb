module Filterable

  class FilterCondition

    attr_reader :name, :scope, :column

    @@default_strategy = {:string => [:like, :begins_with, :ends_with],
                          :text => [:like, :begins_with, :ends_with],
                          :integer => [:equal, :between], :date => [:equal, :between]
                         }


    @@patterns = {:like         => /^\*(.*?)\*$/,
                  :ends_with    => /^\*(.*?)$/,
                  :begins_with  => /^(.*?)\*$/,
                  :between      => /^(-?\d+)\s?-\s?(-?\d+)$/
                 }

    def initialize table, options
      @column     = "#{options[:table]}.#{options[:column]}"
      @name       = options[:name]
      @strategy   = options[:strategy] || @@default_strategy[options[:column_type]]
      @scope      = scope_rails_2(table)
    end


  protected

    def scope_rails_2 table
      table.named_scope @name, lambda {|value|
        {:conditions => condition(value)}
      }
    end

    def scope_rails_3 table
      table.scope @name, lambda {|value|
        where condition(value)
      }
    end

    def condition value
      strategy = strategy_for(value)
      send(strategy, value)
    end

    def strategy_for value
      if @strategy.instance_of? Array
        strategy = parse(value) if @strategy.include? strategy
      else
        @strategy
      end
    end

    def parse value
      case value
        when @@patterns[:like]
          value = $1
          :like
        when @@patterns[:begins_with]
          value = $1
          :ends_with
        when @@patterns[:ends_with]
          value = $1
          :begins_with
        when @@patterns[:between]
          :between
        else
          :equal
      end
    end

    def begins_with value
      ["#{column} LIKE ?", "#{value}%"]
    end

    def ends_with value
      ["#{column} LIKE ?", "%#{value}"]
    end

    def like value
      ["#{column} LIKE ?", "%#{value}%"]
    end

    def between value
      matchdata = @@patterns[:between].match(value)
      ["#{column} BETWEEN ? AND ?", matchdata[1], matchdata[2] ]
    end

    def equal value
      {column => value}
    end

  end

end