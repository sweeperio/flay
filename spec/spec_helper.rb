require "simplecov"
require "coveralls"

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter "shared/"
end

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "flay"
require "pry"

Dir["./spec/support/**/*.rb"].each { |f| require f }
