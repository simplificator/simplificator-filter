require 'test_helper'

class OrdersWithOrdering < ActiveRecord::Base
  set_table_name 'orders'

  include Orderable
  order_definition do
    name :attribute => 'product_name'
    price
    purchased_at
  end
  scope :cheap, where("price < 15")
  scope :carpets, :conditions => ["product_name LIKE ?", "%carpet%"]
end

class TestFilterable < Test::Unit::TestCase

  context "Orderable" do

    context "order_definition" do

      should "have a order definition" do
        assert_instance_of Orderable::OrderDefinition, OrdersWithOrdering.order_definition
      end

    end

    context "order_by" do

      setup do
        names = ['magic carpet', 'red carpet', 'water bottle', 'whisky bottle']
        0.upto(3) {|i| OrdersWithOrdering.create(:price => (i+1)*10, :product_name => names[i], :purchased_at => i.days.ago.to_date) }
      end


      should "skip order scope" do
        carpets = OrdersWithOrdering.order_by(nil)
        assert_equal 4, carpets.size
        assert_equal 'magic carpet', carpets.first.product_name
      end

      should "skip order scope 2" do
        carpets = OrdersWithOrdering.order_by(nil).carpets
        assert_equal 2, carpets.size
        assert_equal 'magic carpet', carpets.first.product_name
      end

      should "order all carpets descending" do
        carpets = OrdersWithOrdering.order_by(:name => 'desc').carpets
        assert_equal 2, carpets.size
        assert_equal 'red carpet', carpets.first.product_name
      end

      should "order all carpets ascending" do
        carpets = OrdersWithOrdering.order_by(:name => 'asc').carpets
        assert_equal 2, carpets.size
        assert_equal 'magic carpet', carpets.first.product_name
      end

      should "order cheaper carpert" do
        carpets = OrdersWithOrdering.order_by(:name => 'carpet').cheap
        assert_equal 1, carpets.size
        assert_equal 'magic carpet', carpets.first.product_name
      end

      should "order cheaper carpert too" do
        carpets = OrdersWithOrdering.cheap.order_by(:name => 'carpet')
        assert_equal 1, carpets.size
        assert_equal 'magic carpet', carpets.first.product_name
      end

    end

    teardown do
      cleanup_database
    end

  end

end
