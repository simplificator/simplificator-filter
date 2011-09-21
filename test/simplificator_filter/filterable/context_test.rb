require 'test_helper'

class OrdersWithFilter < ActiveRecord::Base
  set_table_name 'orders'

  include Filterable
  filter_definition do
    fuzzy_name     :strategy => :like, :attribute => 'product_name'
    cstmr          :strategy => :like, :attribute => 'customer.name'
    price_range    :strategy => :between, :attribute => 'price'
    purchased_at   :strategy => :equal
  end
  scope :cheap, where("price < 15")
  scope :carpets, :conditions => ["product_name LIKE ?", "%carpet%"]

  belongs_to :customer
end

class TestFilterable < Test::Unit::TestCase
  context "Orders with various scopes" do

    setup do
      names = ['magic carpet', 'red carpet', 'water bottle', 'whisky bottle']
      0.upto(3) {|i| OrdersWithFilter.create(:price => (i+1)*10, :product_name => names[i], :purchased_at => i.days.ago) }
    end

    should "skip filter scope" do
      carpets = OrdersWithFilter.filter_by(nil)
      assert_equal({}, carpets.filters)
    end

    should "skip filter scope 2" do
      carpets = OrdersWithFilter.filter_by(nil).cheap
      assert_equal({}, carpets.filters)
    end

    should "find all carpets" do
      carpets = OrdersWithFilter.filter_by(:fuzzy_name => 'carpet')
      assert_equal({:fuzzy_name => {:matches => '%carpet%'}}, carpets.filters)
    end

    should "find expensiver carpet" do
      carpets = OrdersWithFilter.filter_by(:fuzzy_name => 'carpet', :price_range => '15 - 45')
      assert_equal({:fuzzy_name=>{:matches=>"%carpet%"}, :price_range=>{:in=>"15".."45"}}, carpets.filters)
    end

    should "find red carpet" do
      carpets = OrdersWithFilter.filter_by(:fuzzy_name => 'carpet', :price_range => '15 - 45', :purchased_at => 1.day.ago.to_date)
      assert_equal({
        :fuzzy_name=>{:matches=>"%carpet%"},
        :purchased_at=>{:eq=>1.day.ago.to_date},
        :price_range=>{:in=>"15".."45"}
        }, carpets.filters)
    end

    should "find custom filter name with association" do
      carpets = OrdersWithFilter.filter_by(:cstmr => 'test')
      assert_equal({:cstmr => {:matches => '%test%'}}, carpets.filters)
    end

    teardown do
      cleanup_database
    end
  end

end
