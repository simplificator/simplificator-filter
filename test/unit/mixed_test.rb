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

  named_scope :carpet, lambda {|value| {:context => {:name => value}}} # :context => {:name => 'carpet'} #
  named_scope :cheap, lambda {|value| {:context => {:price => value}}}  # :context => {:price => 'cheap'}  #
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

    should 'be able to chain order_by and filter_by' do
      result = Bar.order_by(:product_name => 'desc').filter_by(:fuzzy_name => 'pet')
      assert_equal 2, result.size
      assert_equal 'red carpet', result.first.product_name
      assert_equal({:filters => {:fuzzy_name => 'pet'}, :order => {:product_name => :desc}}, result.context)
    end

    should "have same context indedepent of the position of filter_by" do
      leading = Bar.filter_by(:fuzzy_name => 'pet').carpet('carpet').cheap('cheap')
      rear = Bar.carpet('carpet').cheap('cheap').filter_by(:fuzzy_name => 'pet')
      assert_equal leading.context, rear.context
    end

    teardown do
      cleanup_database
    end

  end

end
