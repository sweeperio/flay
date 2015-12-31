require "aruba/cucumber"
require "chef_gen/flavors/cucumber"

Aruba.configure do |config|
  config.log_level    = :fatal
  config.exit_timeout = 30
end
