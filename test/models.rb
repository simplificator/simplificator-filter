class Order < ActiveRecord::Base
  belongs_to :customer
end

class Customer < ActiveRecord::Base
  has_many    :orders
  belongs_to  :city
end

class City < ActiveRecord::Base
  has_many    :customers
end

def seed_orders
  city = City.create(:name => 'Zurich')
  customer = Customer.create(:name => 'Aladin', :city => city)
  Order.create(:customer => customer, :product_name => 'magic carpet', :price => 500, :purchased_at => '2010-07-22')
  Order.create(:customer => customer, :product_name => 'old lamp', :price => 5, :purchased_at => '2010-07-22')
end

def cleanup_database
  City.delete_all
  Customer.delete_all
  Order.delete_all
end