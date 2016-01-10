require "simplecov"
require "coveralls"

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter "shared/"
end

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "chef/knife/data_bag_encrypt"
require "chef/knife/data_bag_decrypt"
require "flay"
require "pry"

require "./shared/flavor/flay/libraries/cookbook"
Dir["./spec/support/**/*.rb"].each { |f| require f }
