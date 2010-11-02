require 'test_helper'

class Foo < ActiveRecord::Base
  set_table_name 'orders'

  include Filterable
  filter_definition do
    fuzzy_name  :strategy => :like, :attribute => 'product_name', :include_blank => true
    price_range :strategy => :between, :attribute => 'price'
    purchased_at :strategy => :equal
  end
  scope :cheap, where("price < 15")
  scope :carpets, :conditions => ["product_name LIKE ?", "%carpet%"]
end

class TestFilterable < Test::Unit::TestCase

  context "Filterbale" do

    context "filter_definition" do

      should "have a filter definition" do
        assert_instance_of Filterable::FilterDefinition, Foo.filter_definition
      end

    end

    context "filter_by" do

      setup do
        names = ['magic carpet', 'red carpet', 'water bottle', 'whisky bottle']
        0.upto(3) {|i| Foo.create(:price => (i+1)*10, :product_name => names[i], :purchased_at => i.days.ago.to_date) }
      end


      should "skip filter scope" do
        carpets = Foo.filter_by(nil)
        assert_equal 4, carpets.size
      end

      should "skip filter scope 2" do
        carpets = Foo.filter_by(nil).cheap
        assert_equal 1, carpets.size
      end

      should "find all carpets" do
        carpets = Foo.filter_by(:fuzzy_name => 'carpet')
        assert_equal 2, carpets.size
      end

      should "find cheaper carpert" do
        carpets = Foo.filter_by(:fuzzy_name => 'carpet').cheap
        assert_equal 1, carpets.size
        assert_equal 'magic carpet', carpets.first.product_name
      end

      should "find cheaper carpert too" do
        carpets = Foo.cheap.filter_by(:fuzzy_name => 'carpet')
        assert_equal 1, carpets.size
        assert_equal 'magic carpet', carpets.first.product_name
      end

      should "find expensiver carpet" do
        carpets = Foo.filter_by(:fuzzy_name => 'carpet', :price_range => '15 - 45')
        assert_equal 1, carpets.size
        assert_equal 'red carpet', carpets.first.product_name
      end

      should "find red carpet" do
        carpets = Foo.filter_by(:fuzzy_name => 'carpet', :price_range => '15 - 45', :purchased_at => 1.day.ago.to_date)
        assert_equal 1, carpets.size
        assert_equal 'red carpet', carpets.first.product_name
      end

      should "find water bottle" do
        orders = Foo.filter_by(:price_range => '15 - 45').all(:conditions => {:product_name => 'water bottle'})
        assert_equal 1, orders.size
        assert_equal 'water bottle', orders.first.product_name
      end

      should "accept blank for fuzzy name" do
        orders = Foo.filter_by(:fuzzy_name => '')
        assert_not_equal({}, orders.filters)
      end

      should "not accept blank for price range" do
        orders = Foo.filter_by(:price_range => '')
        assert_equal({}, orders.filters)
      end

    end

    teardown do
      cleanup_database
    end

  end

end
