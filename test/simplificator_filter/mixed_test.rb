require 'test_helper'

class Bar < ActiveRecord::Base
  set_table_name 'orders'

  include Filterable
  filter_definition do
    fuzzy_name  :strategy => :like, :attribute => 'product_name'
  end

  include Orderable
  order_definition do
    product_name
  end

  scope :cheap, where("price < 15")
  scope :carpet, :conditions => ["product_name LIKE ?", "%carpet%"]
end

class MixedTest < Test::Unit::TestCase

  context "Some objects with filterable and orderable" do

    setup do
      names = ['magic carpet', 'red carpet', 'water bottle', 'whisky bottle']
      0.upto(3) {|i| Bar.create(:price => (i+1)*10, :product_name => names[i], :purchased_at => i.days.ago) }
    end

    should 'be able to chain filter_by and order_by' do
      result = Bar.filter_by(:fuzzy_name => 'pet').order_by(:product_name => 'desc')
      assert_equal 2, result.size
      assert_equal 'red carpet', result.first.product_name
      assert_equal({:fuzzy_name => {:matches => '%pet%'}}, result.filters)
      assert_equal({:product_name => :desc}, result.sorts)
    end

    should 'be able to chain order_by and filter_by' do
      result = Bar.order_by(:product_name => 'asc').filter_by(:fuzzy_name => 'pet')
      assert_equal 2, result.size
      assert_equal 'magic carpet', result.first.product_name
      assert_equal({:fuzzy_name => {:matches => '%pet%'}}, result.filters)
      assert_equal({:product_name => :asc}, result.sorts)
    end

    should "have same context independent of the position of filter_by" do
      leading = Bar.filter_by(:fuzzy_name => 'pet').carpet('carpet').cheap('cheap')
      rear = Bar.carpet('carpet').cheap('cheap').filter_by(:fuzzy_name => 'pet')
      assert_equal leading.filters, rear.filters
      assert_equal leading.sorts, rear.sorts
    end

    teardown do
      cleanup_database
    end

  end

end
