require 'test_helper'

class TestAssociations < Test::Unit::TestCase

  context "order with associations" do

    setup do
      City.class_eval do
        include Filterable
        default_filters_for_all_attributes
      end

      Customer.class_eval do
        include Filterable
        filter_definition do |filter|
          filter.city :association => :city, :filter => 'name'
        end
        default_filters_for_all_attributes
      end

      Order.class_eval do
        include Filterable
        filter_definition do |filter|
          filter.customer_name :association => :customer, :filter => 'name'
          filter.city :association => :customer, :filter => 'city'
        end
        default_filters_for_all_attributes
      end

      ['Zurich', 'Basel'].each do |city|
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

    context "filter_definition" do

      should "x" do
        true
      end

      should "find all carpet products" do
        orders = Order.filter_by(:product_name => 'carpet').all(:joins => :customer)
        assert_equal 4, orders.size
      end

      should "find all products purchased by Meiers" do
        orders = Order.filter_by(:customer_name => 'Meier').all(:joins => :customers)
        assert_equal 4, orders.size
      end

      should "find all products purchased from customers in Zurich" do
        Order.filter_by(:city => 'Zurich').all(:joins => {:customers => :city})
        assert_equal 4, orders.size
      end

      should "find all products purchased from Meier in Zurich" do
        Order.filter_by(:city => 'Zurich', :customer_name => 'Meier').all(:joins => {:customers => :city})
        assert_equal 2, orders.size
      end

    end

  end

end