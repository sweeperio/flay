$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "flay"

Dir["./spec/support/**/*.rb"].each { |f| require f }
