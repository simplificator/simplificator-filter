module Filterable

  class FilterCondition

    attr_reader :name, :scope, :column#, :base


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

    def initialize base, options
      #@base               = base
      raise ArgumentError, "no default strategy defined for '#{options[:attribute_type]}'" unless @@default_strategy[options[:attribute_type]]
      @column             = "#{ActiveRecord::Base.connection.quote_column_name(options[:table])}.#{ActiveRecord::Base.connection.quote_column_name(options[:attribute])}"
      @name               = "#{options[:name]}_filter"
      @strategy           = options[:strategy] || @@default_strategy[options[:attribute_type]][:patterns]
      @default_strategy   = options[:strategy] || @@default_strategy[options[:attribute_type]][:default]
      @scope              = scope_rails_2(base)
    end


  protected

    def scope_rails_2 base
      base.named_scope @name, lambda {|value|
        {:conditions => condition(value)}
      }
    end

    def scope_rails_3 base
      base.scope @name, lambda {|value|
        where condition(value)
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
      ["#{column} = ?", value]
    end

  end

end