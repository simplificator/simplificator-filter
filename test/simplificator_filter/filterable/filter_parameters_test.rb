require 'test_helper'

class FooFilterOrder < ActiveRecord::Base
  set_table_name 'orders'
  include Filterable
  default_filters_for_all_attributes
end

class FilterParametersTest < Test::Unit::TestCase

  context "filter parameters" do

    context "without parameters" do

      setup do
        @filter_parameters = Filterable::FilterParameters.new(FooFilterOrder)
      end

      should "respond to getter" do
        assert_respond_to @filter_parameters, :product_name
        assert_respond_to @filter_parameters, :price
        assert_respond_to @filter_parameters, :purchased_at
      end

      should "respond to setter" do
        assert_respond_to @filter_parameters, :product_name=
        assert_respond_to @filter_parameters, :price=
        assert_respond_to @filter_parameters, :purchased_at=
      end

      should "not respond to unknown getter" do
        assert !@filter_parameters.respond_to?(:foo)
        assert_raise NoMethodError do
          @filter_parameters.foo
        end
      end

      should "not respond to unknown setter" do
        assert !@filter_parameters.respond_to?(:foo=)
        assert_raise NoMethodError do
          @filter_parameters.foo = 4
        end
      end
    end

    context "with parameters" do

      setup do
        @filter_parameters = Filterable::FilterParameters.new(FooFilterOrder, :product_name => 'carpet', :price => 555)
      end
      should "hold the value of the parameter" do
        assert_equal 'carpet', @filter_parameters.product_name
        assert_equal 555, @filter_parameters.price
        assert_nil @filter_parameters.purchased_at
      end
    end
  end
end