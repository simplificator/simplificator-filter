module Filterable

  class FilterParameters < Hash

    def initialize base, options = {}
      base.filter_definition.keys.each {|key| self[key.to_sym] = nil}
      options.each {|key, value| self[key.to_sym] = value} if options
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