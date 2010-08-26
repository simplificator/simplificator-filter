module Filterable

  class FilterParameters < ScopeLogic::ScopeParameters

    def initialize base, options = {}
      super :filter, base, options
    end

  end

end