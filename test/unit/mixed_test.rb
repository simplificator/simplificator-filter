require 'test_helper'

class Bar < ActiveRecord::Base
  set_table_name 'orders'

  include Filterable
  filter_definition do |filter|
    filter.fuzzy_name  :strategy => :like, :attribute => 'product_name'
  end

  include Orderable
  order_definition do |order|
    order.product_name
  end
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
      assert_equal({:filters => {:fuzzy_name => 'pet'}, :order => {:product_name => :desc}}, result.context)
    end

    teardown do
      cleanup_database
    end

  end

end
