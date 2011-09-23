require 'test_helper'

class CityO < City
  include Orderable
  default_orders_for_all_attributes
end

class CustomerO < Customer
  include Orderable
  order_definition do
    city :attribute => 'city.name'
  end
  default_orders_for_all_attributes
end

class OrderO < Order
  include Orderable
  order_definition do
    customer_name :attribute => 'customer.name'
    city :attribute => 'customer.city.name'
  end
  default_orders_for_all_attributes
end

class TestAssociations < Test::Unit::TestCase

  context "an order with associations" do

    setup do
      ['Zürich', 'Basel'].each do |city|
        city = CityO.create(:name => city)
        ['Meier', 'Müller'].each do |name|
          customer = CustomerO.create(:name => name, :city => city)
          ['magic carpet', 'whisky bottle'].each_with_index do |product, i|
            OrderO.create(:customer => customer, :product_name => product, :price => (i+1)*100, :purchased_at => i.days.ago)
          end
        end
      end
    end

    teardown do
      cleanup_database
    end

    context "order_definition" do

      should "order all products purchased by customer name ascending" do
        orders = OrderO.order_by(:customer_name => 'asc')
        assert_equal 8, orders.size
        assert_equal 'Meier', orders.first.customer.name
      end

      should "order all products purchased by customer name descending" do
        orders = OrderO.order_by(:customer_name => 'desc')
        assert_equal 8, orders.size
        assert_equal 'Müller', orders.first.customer.name
      end

      should "order all products purchased by city name ascending" do
        orders = OrderO.order_by(:city => 'asc')
        assert_equal 8, orders.size
        assert_equal 'Basel', orders.first.customer.city.name
      end

      should "order all products purchased by city name descending" do
        orders = OrderO.order_by(:city => 'desc')
        assert_equal 8, orders.size
        assert_equal 'Zürich', orders.first.customer.city.name
      end

      should "order all products purchased by city name descending and customer name descending" do
        orders = OrderO.order_by(:city => 'desc', :customer_name => 'desc')
        assert_equal 8, orders.size
        assert_equal 'Zürich', orders.first.customer.city.name
        assert_equal 'Müller', orders.first.customer.name
      end
    end
  end
end
