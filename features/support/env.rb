require "aruba/cucumber"
require "chef_gen/flavors/cucumber"

Before do
  @aruba_timeout_seconds = 30
end
