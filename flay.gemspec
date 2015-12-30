# coding: utf-8
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "flay/version"

Gem::Specification.new do |spec|
  spec.name          = "chef-flavor-flay"
  spec.version       = Flay::VERSION
  spec.authors       = ["pseudomuto"]
  spec.email         = ["developers@sweeper.io"]

  spec.summary       = "A Chef cookbook generator using [chef-gen-flavors](https://rubygems.org/gems/chef-gen-flavors)"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/sweeperio/flay"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "chef-gen-flavors", "~> 0.9"
  spec.add_runtime_dependency "thor", "~> 0.0"

  spec.post_install_message = <<-EOM
  Thanks for installing chef-flavor-flay! Be sure to update your knife.rb file
  as outlined in the README at #{spec.homepage}
  EOM
end
