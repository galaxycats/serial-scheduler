require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_support/test_case'
require 'active_support/core_ext'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'serial-scheduler'

class Test::Unit::TestCase
end
