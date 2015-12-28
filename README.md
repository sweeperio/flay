# Flay - cuz Bobby Flay seems like a pretty good chef

[![Build Status](https://travis-ci.org/sweeperio/flay.svg?branch=master)](https://travis-ci.org/sweeperio/flay)

This repo is a custom cookbook/recipe template for use with the [ChefDK].

[ChefDK]: https://downloads.chef.io/chef-dk/

## Installation

* Make sure you've installed the [ChefDK]
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
`chef generate recipe my_recipe`

You'll be presented with a set of options, choose `flay`

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

