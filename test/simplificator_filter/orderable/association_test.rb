require 'test_helper'

class TestAssociations < Test::Unit::TestCase

  context "an order with associations" do

    setup do
      City.class_eval do
        include Orderable
        default_orders_for_all_attributes
      end

      Customer.class_eval do
        include Orderable
        order_definition do
          city :attribute => 'city.name'
        end
        default_orders_for_all_attributes
      end

      Order.class_eval do
        include Orderable
        order_definition do
          customer_name :attribute => 'customer.name'
          city :attribute => 'customer.city.name'
        end
        default_orders_for_all_attributes
      end

      ['Zürich', 'Basel'].each do |city|
        city = City.create(:name => city)
        ['Meier', 'Müller'].each do |name|
          customer = Customer.create(:name => name, :city => city)
          ['magic carpet', 'whisky bottle'].each_with_index do |product, i|
            Order.create(:customer => customer, :product_name => product, :price => (i+1)*100, :purchased_at => i.days.ago)
          end
        end
      end
    end

    teardown do
      cleanup_database
    end

    context "order_definition" do

      should "order all products purchased by customer name ascending" do
        orders = Order.order_by(:customer_name => 'asc')
        assert_equal 8, orders.size
        assert_equal 'Meier', orders.first.customer.name
      end

      should "order all products purchased by customer name descending" do
        orders = Order.order_by(:customer_name => 'desc')
        assert_equal 8, orders.size
        assert_equal 'Müller', orders.first.customer.name
      end

      should "order all products purchased by city name ascending" do
        orders = Order.order_by(:city => 'asc')
        assert_equal 8, orders.size
        assert_equal 'Basel', orders.first.customer.city.name
      end

      should "order all products purchased by city name descending" do
        orders = Order.order_by(:city => 'desc')
        assert_equal 8, orders.size
        assert_equal 'Zürich', orders.first.customer.city.name
      end

      should "order all products purchased by city name descending and customer name descending" do
        orders = Order.order_by(:city => 'desc', :customer_name => 'desc')
        assert_equal 8, orders.size
        assert_equal 'Zürich', orders.first.customer.city.name
        assert_equal 'Müller', orders.first.customer.name
      end

    end

  end

end
