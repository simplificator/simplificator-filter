$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib', 'simplificator_filter'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'simplificator-filter'
require 'test/unit'
require 'shoulda'

#ActiveRecord::Base.logger = Logger.new(STDOUT)
#ActiveRecord::Base.logger.level = Logger::DEBUG

require File.join(File.dirname(__FILE__), 'models')

def db_setup(name)
  database_yml = YAML.load_file(File.join(File.dirname(__FILE__), 'database.yml'))
  ActiveRecord::Base.establish_connection(database_yml[name])
  ActiveRecord::Base.configurations = true
  db_migrate
end

def db_migrate
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
end

db_setup('sqlite')
