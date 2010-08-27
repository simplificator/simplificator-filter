require 'test_helper'

class Foo < ActiveRecord::Base
  set_table_name 'orders'

  include Filterable
  filter_definition do
    fuzzy_name  :strategy => :like, :attribute => 'product_name', :include_blank => true
    price_range :strategy => :between, :attribute => 'price'
    purchased_at :strategy => :equal
  end
  named_scope :cheap, :conditions => ["price < 15"]
  named_scope :carpets, :conditions => ["product_name LIKE ?", "%carpet%"]
end

class TestFilterable < Test::Unit::TestCase

  context "Filterbale" do

    context "filter_definition" do

      #should "return filter parameters object" do
      #  assert_instance_of Filterable::FilterParameters, Foo.filter
      #end

      should "have a filter definition" do
        assert_instance_of Filterable::FilterDefinition, Foo.filter_definition
      end

      #should "accessors for fuzzy_name" do
      #  assert_respond_to Foo.filter, :fuzzy_name
      #  assert_respond_to Foo.filter, :fuzzy_name=
      #end


    end

    context 'filter' do
=begin
      should 'provide an empty filter' do
        assert Foo.filter
      end

      should 'accept empty parameters for filter' do
        assert Foo.filter({})
      end

      should 'not accept unknown parameters for filter' do
        assert_raise NoMethodError do
          Foo.filter({:bar => 'baz'})
        end
      end

      should 'accept known parameters for filter' do
        assert_equal 'baz', Foo.filter({:fuzzy_name => 'baz'}).fuzzy_name
      end
=end
    end

    context "filter_by" do

      setup do
        names = ['magic carpet', 'red carpet', 'water bottle', 'whisky bottle']
        0.upto(3) {|i| Foo.create(:price => (i+1)*10, :product_name => names[i], :purchased_at => i.days.ago) }
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
        carpets = Foo.filter_by(:fuzzy_name => 'carpet', :price_range => '15 - 45', :purchased_at => 1.day.ago)
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
        assert_not_equal({}, orders.context)
      end

      should "not accept blank for price range" do
        orders = Foo.filter_by(:price_range => '')
        assert_equal({}, orders.context)
      end

    end

    teardown do
      cleanup_database
    end

  end

end