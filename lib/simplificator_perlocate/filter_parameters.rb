module Filterable

  class FilterParameters < Hash

    def initialize base, options = {}
      create_accessors base
      options.each {|key, value| send("#{key}=", value)}
      @errors = ActiveRecord::Errors.new(base)
    end

    def create_accessors base
      self.class.instance_eval do
        base.filter_definition.keys.each do |key|
          define_method(key) do
            instance_variable_get("@#{key}")
          end
          define_method("#{key}=") do |value|
            instance_variable_set("@#{key}", value)
          end
        end
      end
    end

  end

end