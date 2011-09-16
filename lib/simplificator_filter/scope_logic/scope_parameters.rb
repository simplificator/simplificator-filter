module ScopeLogic

  class ScopeParameters < Hash

    def initialize strategy_name, base, options = {}
      raise ArgumentError, "has a #{strategy_name} definition been made for model #{base.name}" unless base.read_inheritable_attribute("@#{strategy_name}_definition")
      base.read_inheritable_attribute("@#{strategy_name}_definition").keys.each {|key| self[key.to_sym] = nil}
      options.each do |key, value|
        raise NoMethodError, "undefined method '#{key}' for #{self.inspect}::#{self.class}" unless has_key?(key.to_sym)
        self[key.to_sym] = value
      end if options
    end

    def respond_to? name
      has_key?(name) || has_key?(name_without_setter(name))
    end

    def name_without_setter name
      if matchdata = /(.*?)=$/.match(name.to_s)
        matchdata[1].to_sym
      end
    end

    def method_missing name, *args, &block
      if has_key?(name)
        self[name]
      elsif has_key?(name_without_setter(name))
        self[name_without_setter(name)] = *args
      else
        super
      end
    end

  end

end