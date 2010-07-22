ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Base.configurations = true

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define(:version => 1) do
  create_table :orders do |t|
    t.string  :product_name
    t.integer :price
    t.date    :purchased_at
    t.integer :customer_id
  end

  create_table :customers do |t|
    t.string  :name
    t.integer :credit
    t.integer :city_id
  end

  create_table :cities do |t|
    t.string  :name
  end

end

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