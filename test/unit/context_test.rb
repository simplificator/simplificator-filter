require 'test_helper'

class Foo < ActiveRecord::Base
  set_table_name 'orders'

  include Filterable
  filter_definition do
    fuzzy_name  :strategy => :like, :attribute => 'product_name'
    price_range :strategy => :between, :attribute => 'price'
    purchased_at :strategy => :equal
  end
  named_scope :cheap, :conditions => ["price < 15"]
  named_scope :carpets, :conditions => ["product_name LIKE ?", "%carpet%"]
end

class TestFilterable < Test::Unit::TestCase
  context "Orders with various scopes" do

    setup do
      names = ['magic carpet', 'red carpet', 'water bottle', 'whisky bottle']
      0.upto(3) {|i| Foo.create(:price => (i+1)*10, :product_name => names[i], :purchased_at => i.days.ago) }
    end

    should "skip filter scope" do
      carpets = Foo.filter_by(nil)
      assert_equal({}, carpets.context)
    end

    should "skip filter scope 2" do
      carpets = Foo.filter_by(nil).cheap
      assert_equal({}, carpets.context)
    end

    should "find all carpets" do
      carpets = Foo.filter_by(:fuzzy_name => 'carpet')
      assert_equal ({:filters => {:fuzzy_name => 'carpet'}}), carpets.context
    end

    should "find expensiver carpet" do
      carpets = Foo.filter_by(:fuzzy_name => 'carpet', :price_range => '15 - 45')
      assert_equal ({:filters => {:fuzzy_name => 'carpet', :price_range => '15 - 45'}}), carpets.context
    end

    should "find red carpet" do
      carpets = Foo.filter_by(:fuzzy_name => 'carpet', :price_range => '15 - 45', :purchased_at => 1.day.ago.to_date)
      assert_equal ({:filters => {:fuzzy_name => 'carpet', :price_range => '15 - 45', :purchased_at => 1.day.ago.to_date}}), carpets.context
    end

    teardown do
      cleanup_database
    end
  end

end
