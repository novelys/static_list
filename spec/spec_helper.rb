require 'rspec'
require "active_support/core_ext"

require File.join(File.dirname(__FILE__), '..', 'lib', 'static_list')

RSpec.configure do |config|
  config.mock_with :rspec
end

