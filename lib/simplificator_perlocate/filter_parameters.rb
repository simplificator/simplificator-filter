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
      /(.*?)=$/.match(name.to_s)[1].try(:to_sym)
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