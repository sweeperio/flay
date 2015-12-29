# Flay - A Customizable Chef Cookbook Template

[![Build Status](https://travis-ci.org/sweeperio/flay.svg?branch=master)](https://travis-ci.org/sweeperio/flay)
[![Gem Version](https://badge.fury.io/rb/chef-flavor-flay.svg)](https://badge.fury.io/rb/chef-flavor-flay)
[![Coverage Status](https://coveralls.io/repos/sweeperio/flay/badge.svg?branch=master&service=github)](https://coveralls.io/github/sweeperio/flay?branch=master)

This repo is a custom cookbook/recipe template for use with the [ChefDK]. It uses [chef-gen-flavors] to create a custom
template that can be used with `chef generate [cookbook|recipe]` commands. 

It's pretty opinionated, but you could easily modify it to suit your needs, by modifying things in the 
`shared/flavor/flay` directory.

[ChefDK]: https://downloads.chef.io/chef-dk/
[chef-gen-flavors]: https://github.com/jf647/chef-gen-flavors

## Why?

* Automatically create boilerplate cookbook code/files
* Put some standards in place that are used consistently across all cookbooks
* Generate simple, good examples for devs that are new to chef

## What?

* Normal setup in place...[Berkshelf], [ChefSpec], [Test Kitchen], etc.
* Only ubuntu is supported and setup in ChefSpec and Test Kitchen (I said it was opinionated)
* Adds [core] cookbook to the Berksfile
* Adds [rubocop] with some updated (opinionated) settings
* Updates all templates to pass `bundle exec rubocop && bundle exec rspec`
* Adds a travis file for CI that will cache it's bundle for #webscale
* Ensures `berks`, `chef`, `chefspec` and `rubocop` are in the Gemfile (pessimistically locked to current major version)
* Creates a single `test` directory rather than spec/unit and test/integration
* Adds a _dummy_ `encrypted_data_bag_secret` file for [Test Kitchen]
* Adds `encrypt_data_bag` rake task for working with encrypted data bags in [Test Kitchen] (see note below)

### Testing Encrypted Data Bags

In order to make testing encrypted data bags easier, there's a convention (and rake task) in place in this template.

The _test/integration/data_bags_ directory should contain subdirectories for each data bag you want to test (just like 
your chef repo would).

**To create an encrypted data bag item, follow these steps (assuming you're testing ejson/keys):**

* Create `test/integration/data_bags/ejson/keys.plaintext.json` and add your items
* Run `bundle exec rake encrypt_data_bag[ejson,keys]` (zsh users, you'll need to quote, escape or `unsetopt nomatch`)
* Notice that `test/integration/data_bags/ejson/keys.json` has been created and contains the encrypted contents

Updating follows the exact same process.

[Berkshelf]: https://docs.chef.io/berkshelf.html
[ChefSpec]: https://docs.chef.io/chefspec.html
[Test Kitchen]: https://docs.chef.io/kitchen.html
[core]: https://github.com/sweeperio/chef-core
[rubocop]: https://docs.chef.io/rubocop.html

## Installation

* Make sure you've installed the [ChefDK]
* Run `chef gem install chef-flavor-flay`

Add the following to your `knife.rb` file:

```ruby
if defined?(ChefDK::CLI)
  require "chef_gen/flavors"
  chefdk.generator_cookbook = ChefGen::Flavors.path
end
```

Celebrate! :rocket:

## Usage

* `chef generate cookbook my_cookbook`
* `chef generate recipe my_recipe` (from within the cookbook directory)

If you're using this for sweeper cookbooks you should use these instead. They simply call the normal generate methods
but pass parameters for maintainer, email and license.

* `chef exec flay cookbook my_cookbook`
* `chef exec flay recipe my_cookbook`

### Example

```
$ chef generate cookbook chef-demo-flay

using ChefGen flavor 'flay'
Compiling Cookbooks...
Recipe: flay::cookbook
  * directory[/Users/pseudomuto/chef-demo-flay] action create
    - create new directory /Users/pseudomuto/chef-demo-flay
  * directory[/Users/pseudomuto/chef-demo-flay/.bundle] action create
    - create new directory /Users/pseudomuto/chef-demo-flay/.bundle
  * directory[/Users/pseudomuto/chef-demo-flay/recipes] action create
    - create new directory /Users/pseudomuto/chef-demo-flay/recipes
  * cookbook_file[/Users/pseudomuto/chef-demo-flay/.gitignore] action create
    - create new file /Users/pseudomuto/chef-demo-flay/.gitignore
    - update content in file /Users/pseudomuto/chef-demo-flay/.gitignore from none to 93f78f
    (diff output suppressed by config)
  * cookbook_file[/Users/pseudomuto/chef-demo-flay/.rubocop.yml] action create
    - create new file /Users/pseudomuto/chef-demo-flay/.rubocop.yml
    - update content in file /Users/pseudomuto/chef-demo-flay/.rubocop.yml from none to 53e0ba
    (diff output suppressed by config)
  * cookbook_file[/Users/pseudomuto/chef-demo-flay/Berksfile] action create_if_missing
    - create new file /Users/pseudomuto/chef-demo-flay/Berksfile
    - update content in file /Users/pseudomuto/chef-demo-flay/Berksfile from none to dcbbf1
    (diff output suppressed by config)
  * cookbook_file[/Users/pseudomuto/chef-demo-flay/.bundle/config] action create
    - create new file /Users/pseudomuto/chef-demo-flay/.bundle/config
    - update content in file /Users/pseudomuto/chef-demo-flay/.bundle/config from none to f7385e
    (diff output suppressed by config)
  * cookbook_file[/Users/pseudomuto/chef-demo-flay/chefignore] action create
    - create new file /Users/pseudomuto/chef-demo-flay/chefignore
    - update content in file /Users/pseudomuto/chef-demo-flay/chefignore from none to 51b09a
    (diff output suppressed by config)
  * cookbook_file[/Users/pseudomuto/chef-demo-flay/Gemfile] action create
    - create new file /Users/pseudomuto/chef-demo-flay/Gemfile
    - update content in file /Users/pseudomuto/chef-demo-flay/Gemfile from none to ebb472
    (diff output suppressed by config)
  * cookbook_file[/Users/pseudomuto/chef-demo-flay/Rakefile] action create
    - create new file /Users/pseudomuto/chef-demo-flay/Rakefile
    - update content in file /Users/pseudomuto/chef-demo-flay/Rakefile from none to b03f32
    (diff output suppressed by config)
  * flay_template[/Users/pseudomuto/chef-demo-flay/metadata.rb] action create_if_missing
    * template[/Users/pseudomuto/chef-demo-flay/metadata.rb] action create_if_missing
      - create new file /Users/pseudomuto/chef-demo-flay/metadata.rb
      - update content in file /Users/pseudomuto/chef-demo-flay/metadata.rb from none to 74ceb0
      (diff output suppressed by config)

  * flay_template[/Users/pseudomuto/chef-demo-flay/README.md] action create_if_missing
    * template[/Users/pseudomuto/chef-demo-flay/README.md] action create_if_missing
      - create new file /Users/pseudomuto/chef-demo-flay/README.md
      - update content in file /Users/pseudomuto/chef-demo-flay/README.md from none to a6b92d
      (diff output suppressed by config)

  * directory[/Users/pseudomuto/chef-demo-flay/test/unit/recipes] action create
    - create new directory /Users/pseudomuto/chef-demo-flay/test/unit/recipes
  * cookbook_file[/Users/pseudomuto/chef-demo-flay/.rspec] action create
    - create new file /Users/pseudomuto/chef-demo-flay/.rspec
    - update content in file /Users/pseudomuto/chef-demo-flay/.rspec from none to c64d5e
    (diff output suppressed by config)
  * cookbook_file[/Users/pseudomuto/chef-demo-flay/.travis.yml] action create
    - create new file /Users/pseudomuto/chef-demo-flay/.travis.yml
    - update content in file /Users/pseudomuto/chef-demo-flay/.travis.yml from none to 1d91c7
    (diff output suppressed by config)
  * flay_template[/Users/pseudomuto/chef-demo-flay/recipes/default.rb] action create_if_missing
    * template[/Users/pseudomuto/chef-demo-flay/recipes/default.rb] action create_if_missing
      - create new file /Users/pseudomuto/chef-demo-flay/recipes/default.rb
      - update content in file /Users/pseudomuto/chef-demo-flay/recipes/default.rb from none to ad3596
      (diff output suppressed by config)

  * flay_template[/Users/pseudomuto/chef-demo-flay/test/unit/recipes/default_spec.rb] action create_if_missing
    * template[/Users/pseudomuto/chef-demo-flay/test/unit/recipes/default_spec.rb] action create_if_missing
      - create new file /Users/pseudomuto/chef-demo-flay/test/unit/recipes/default_spec.rb
      - update content in file /Users/pseudomuto/chef-demo-flay/test/unit/recipes/default_spec.rb from none to c1956b
      (diff output suppressed by config)

  * directory[/Users/pseudomuto/chef-demo-flay/test/integration/data_bags/ejson] action create
    - create new directory /Users/pseudomuto/chef-demo-flay/test/integration/data_bags/ejson
  * directory[/Users/pseudomuto/chef-demo-flay/test/integration/default/serverspec] action create
    - create new directory /Users/pseudomuto/chef-demo-flay/test/integration/default/serverspec
  * directory[/Users/pseudomuto/chef-demo-flay/test/integration/helpers/serverspec] action create
    - create new directory /Users/pseudomuto/chef-demo-flay/test/integration/helpers/serverspec
  * cookbook_file[/Users/pseudomuto/chef-demo-flay/test/integration/encrypted_data_bag_secret] action create
    - create new file /Users/pseudomuto/chef-demo-flay/test/integration/encrypted_data_bag_secret
    - update content in file /Users/pseudomuto/chef-demo-flay/test/integration/encrypted_data_bag_secret from none to 4299f4
    (diff output suppressed by config)
  * cookbook_file[/Users/pseudomuto/chef-demo-flay/test/integration/data_bags/ejson/keys.json] action create
    - create new file /Users/pseudomuto/chef-demo-flay/test/integration/data_bags/ejson/keys.json
    - update content in file /Users/pseudomuto/chef-demo-flay/test/integration/data_bags/ejson/keys.json from none to 3e325d
    (diff output suppressed by config)
  * cookbook_file[/Users/pseudomuto/chef-demo-flay/test/integration/data_bags/ejson/keys.plaintext.json] action create
    - create new file /Users/pseudomuto/chef-demo-flay/test/integration/data_bags/ejson/keys.plaintext.json
    - update content in file /Users/pseudomuto/chef-demo-flay/test/integration/data_bags/ejson/keys.plaintext.json from none to 179a27
    (diff output suppressed by config)
  * cookbook_file[/Users/pseudomuto/chef-demo-flay/test/integration/helpers/serverspec/spec_helper.rb] action create_if_missing
    - create new file /Users/pseudomuto/chef-demo-flay/test/integration/helpers/serverspec/spec_helper.rb
    - update content in file /Users/pseudomuto/chef-demo-flay/test/integration/helpers/serverspec/spec_helper.rb from none to bef02f
    (diff output suppressed by config)
  * cookbook_file[/Users/pseudomuto/chef-demo-flay/test/unit/spec_helper.rb] action create_if_missing
    - create new file /Users/pseudomuto/chef-demo-flay/test/unit/spec_helper.rb
    - update content in file /Users/pseudomuto/chef-demo-flay/test/unit/spec_helper.rb from none to 918ad3
    (diff output suppressed by config)
  * flay_template[/Users/pseudomuto/chef-demo-flay/.kitchen.yml] action create_if_missing
    * template[/Users/pseudomuto/chef-demo-flay/.kitchen.yml] action create_if_missing
      - create new file /Users/pseudomuto/chef-demo-flay/.kitchen.yml
      - update content in file /Users/pseudomuto/chef-demo-flay/.kitchen.yml from none to dd0b56
      (diff output suppressed by config)

  * flay_template[/Users/pseudomuto/chef-demo-flay/test/integration/default/serverspec/default_spec.rb] action create_if_missing
    * template[/Users/pseudomuto/chef-demo-flay/test/integration/default/serverspec/default_spec.rb] action create_if_missing
      - create new file /Users/pseudomuto/chef-demo-flay/test/integration/default/serverspec/default_spec.rb
      - update content in file /Users/pseudomuto/chef-demo-flay/test/integration/default/serverspec/default_spec.rb from none to 7fcaa4
      (diff output suppressed by config)

  * execute[initialize-git] action run
    - execute git init .
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

