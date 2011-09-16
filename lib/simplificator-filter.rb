$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'simplificator_filter'))

require 'rubygems'
require 'active_support/all'
require 'active_record'
require 'squeel'

modules = %w{Filterable Orderable}

# Load scope logic
require 'scope_logic/scope_definition'
require 'scope_logic/scope_logic'
require 'scope_logic/scope_parameters'
require 'scope_logic/scope_condition'

# Load all modules
modules.each do |strategy|
  Squeel.configure do |config|
    config.load_core_extensions :hash, :symbol
  end

  Dir.glob(File.join(File.dirname(__FILE__), 'simplificator_filter', strategy.downcase, '*.rb')).each {|file| require file}

  # Add extensions to ActiveRecord::Relation
  ActiveRecord::Relation.instance_eval do
    include strategy.constantize
  end

  ActiveRecord::Base.instance_eval do
    include strategy.constantize
  end
end