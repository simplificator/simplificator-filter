 require 'test_helper'

class TestSimplificatorFilter < Test::Unit::TestCase

  context "Filterable" do

    setup do
      seed_orders
    end

    teardown do
      cleanup_database
    end

    should "have orders" do
      assert_equal 2, Order.count
    end


  end

end
