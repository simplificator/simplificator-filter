require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'redgreen'
require 'active_record'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib', 'simplificator_perlocate'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'simplificator-percolate'

#ActiveRecord::Base.logger = Logger.new(STDOUT)
#ActiveRecord::Base.logger.level = Logger::DEBUG

require File.join(File.dirname(__FILE__), 'models')