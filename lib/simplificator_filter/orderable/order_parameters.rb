module Orderable

  class OrderParameters < ScopeLogic::ScopeParameters

    def initialize base, options = {}
      super :order, base, options
    end

  end

end