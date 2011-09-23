require 'test_helper'

class CityF < City
  include Filterable
  default_filters_for_all_attributes
end

class CustomerF < Customer
  include Filterable
  filter_definition do
    city :attribute => 'city.name'
  end
  default_filters_for_all_attributes
end

class OrderF < Order
  include Filterable
  filter_definition do
    customer_name :attribute => 'customer.name'
    city :attribute => 'customer.city.name'
  end
  default_filters_for_all_attributes
end

class TestAssociations < Test::Unit::TestCase

  context "an order with associations" do

    setup do
      ['Zurich', 'Basel'].each do |city|
        city = CityF.create(:name => city)
        ['Meier', 'Müller'].each do |name|
          customer = CustomerF.create(:name => name, :city => city)
          ['magic carpet', 'whisky bottle'].each_with_index do |product, i|
            OrderF.create(:customer => customer, :product_name => product, :price => (i+1)*100, :purchased_at => i.days.ago)
          end
        end
      end
    end

    teardown do
      cleanup_database
    end

    context "filter_definition" do

      should "find all products purchased by Meiers" do
        orders = OrderF.filter_by(:customer_name => 'Meier')
        assert_equal 4, orders.size
      end

      should "find all products purchased from customers in Zurich" do
        orders = OrderF.filter_by(:city => 'Zurich')
        assert_equal 4, orders.size
      end

      should "find all products purchased from Meier in Zurich" do
        orders = OrderF.filter_by(:city => 'Zurich', :customer_name => 'Meier')
        assert_equal 2, orders.size
      end
    end
  end
end
