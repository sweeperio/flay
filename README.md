# Flay

Bobby Flay is a pretty good chef, so let's piggy back on that.

## Installation

* Make sure you've installed the [ChefDK](https://downloads.chef.io/chef-dk/)
* Run `chef gem install chef-flavor-flay`

Add the following to your `~/knife.rb` file:

```ruby
if defined?(ChefDK::CLI)
  require "chef_gen/flavors"
  chefdk.generator_cookbook = ChefGen::Flavors.path
end
```

Celebrate! :rocket:

## Usage

`chef generate cookbook my_cookbook`

You'll be presented with a set of options, choose `flay`

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

