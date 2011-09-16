require 'test_helper'

class DefaultAll < ActiveRecord::Base
  set_table_name 'orders'

  include Filterable
  default_filters_for_all_attributes
end

class DefaultSome < ActiveRecord::Base
  set_table_name 'orders'

  include Filterable
  default_filters_for_attributes :product_name, :price
end

class TestDefaultFilter < Test::Unit::TestCase

  context "default filter" do

    context "for all attributes" do

      # should "return filter parameters object" do
      #   assert_instance_of Filterable::FilterParameters, DefaultAll.filter
      # end

      should "have a filter definition" do
        assert_instance_of Filterable::FilterDefinition, DefaultAll.filter_definition
      end

      # should "have accessors for product_name" do
      #   assert_respond_to DefaultAll.filter, :product_name
      #   assert_respond_to DefaultAll.filter, :product_name=
      # end
      #
      # should "have accessors for price" do
      #   assert_respond_to DefaultAll.filter, :price
      #   assert_respond_to DefaultAll.filter, :price=
      # end
      #
      # should "have accessors for purchased_at" do
      #   assert_respond_to DefaultAll.filter, :purchased_at
      #   assert_respond_to DefaultAll.filter, :purchased_at=
      # end

    end

    context "for attributes" do

      # should "return filter parameters object" do
      #  assert_instance_of Filterable::FilterParameters, DefaultSome.filter
      # end

      should "have a filter definition" do
        assert_instance_of Filterable::FilterDefinition, DefaultSome.filter_definition
      end

      # should "have accessors for product_name" do
      #   assert_respond_to DefaultSome.filter, :product_name
      #   assert_respond_to DefaultSome.filter, :product_name=
      # end
      #
      # should "have accessors for price" do
      #   assert_respond_to DefaultSome.filter, :price
      #   assert_respond_to DefaultSome.filter, :price=
      # end
      #
      # should "have no accessors for purchased_at" do
      #   assert_raise NoMethodError do
      #     DefaultSome.filter.purchased_at
      #   end
      #   assert_raise NoMethodError do
      #     DefaultSome.filter.purchased_at = '5'
      #   end
      # end
    end

    context "patterns" do

      setup do
        names = ['magic carpet', 'red carpet', 'water bottle', 'whisky bottle']
        0.upto(3) {|i| DefaultAll.create(:price => (i+1)*10, :product_name => names[i], :purchased_at => i.days.ago) }
      end

      teardown do
        cleanup_database
      end

      should "find with different patterns in a row" do
        carpets = DefaultAll.filter_by(:product_name => '*carpet*')
        assert_equal 2, carpets.size
        carpets = DefaultAll.filter_by(:product_name => 'whisky*')
        assert_equal 1, carpets.size
        carpets = DefaultAll.filter_by(:product_name => '*bottle')
        assert_equal 2, carpets.size
        carpets = DefaultAll.filter_by(:product_name => 'water')
        assert_equal 1, carpets.size
      end

      should "not find anything with filter_by chained" do
        carpets = DefaultAll.filter_by(:product_name => '*carpet*').filter_by(:product_name => 'whisky*')
        assert_equal 0, carpets.size
      end

    end
  end
end