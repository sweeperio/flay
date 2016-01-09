# Flay - A Customized Chef Cookbook Template with Other Useful Things

[![Build Status](https://travis-ci.org/sweeperio/flay.svg?branch=master)](https://travis-ci.org/sweeperio/flay)
[![Gem Version](https://badge.fury.io/rb/chef-flavor-flay.svg)](https://badge.fury.io/rb/chef-flavor-flay)
[![Coverage Status](https://coveralls.io/repos/sweeperio/flay/badge.svg?branch=master&service=github)](https://coveralls.io/github/sweeperio/flay?branch=master)

This repo is a custom cookbook/recipe template for use with the [ChefDK]. It uses [chef-gen-flavors] to create a custom
template that can be used with `chef generate [cookbook|recipe]` commands.

It's very opinionated and works with the sweeperio infrastructure specifically.

[ChefDK]: https://downloads.chef.io/chef-dk/
[chef-gen-flavors]: https://github.com/jf647/chef-gen-flavors

## Why?

* Automatically create boilerplate cookbook code/files
* Put some standards in place that are used consistently across all cookbooks
* Generate simple, good examples for devs that are new to chef

## What?

* Normal setup in place...[Berkshelf], [ChefSpec], [Test Kitchen], etc.
* _**Only ubuntu**_ is supported and setup in ChefSpec and Test Kitchen (I said it was opinionated)
* Sets up berks to use our berks api
* Adds [core] cookbook to metadata.rb
* Adds [rubocop] with some updated (opinionated) settings
* Updates all templates to pass `bundle exec rubocop && bundle exec rspec`
* Adds a travis file for CI that will use the chefdk to run tests
* Creates a single `test` directory rather than spec/unit and test/integration
* Adds a _dummy_ `encrypted_data_bag_secret` file for [Test Kitchen] (see note about testing data bags below)

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

* `chef exec flay cookbook my_cookbook`
* `chef exec flay recipe my_cookbook` (from within the cookbook directory)
* `chef exec flay encrypt DATA_BAG ITEM (options)`
* `chef exec flay decrypt DATA_BAG ITEM (options)`
* `chef exec flay release` (see below)

There are a few other commands available. Run `chef exec flay help` for details.

### Releasing Cookbooks

Modelled after bundler's `rake release`, there's `chef exec flay release`.

When the following conditions are met:

* `Dir.pwd` is a git repo (or a subdirectory of one)
* There are no uncommitted changes in git
* _metadata.rb_ exists (at the root of the repo) and contains a valid version

It will run:

* `git tag -a -m "Version #{version}" v#{version}` - unless the tag already exists
* `git push && git push --tags`
* `chef exec berks install`
* `chef exec berks upload`

### Working With Data Bags

Normally data bags are edited directly on the chef server by using the normal `knife data bag` commands. I'm not fond of
this practise because there is no history there. If someone changes an item, how do you go back to what it was if
something goes wrong?

For this reason, I've added a simple knife plugin that exposes 2 new knife commands `data bag encrypt` and `data bag
decrypt`. These commands work with json files in the `data_bags/` directory of your chef repo. The basic idea is that
you encrypt the items locally, commit to git and then create/update the items from json files.

For example, suppose you have an unencrypted json file at `data_bags/ejson/keys.json` that defines an item. To encrypt
this item you can run the following command:

`chef exec knife data bag encrypt ejson keys -w`

This will encrypt the contents using your `encrypted_data_bag_secret` (pulled from chef config/knife.rb).

Similarly there's a `decrypt` version that does the opposite. `knife data bag decrypt ejson keys -w`

Both of these commands support the following options:

* `-w` - whether or not to write the file. If false, the results will be printed to STDOUT, but not written to the file.
    Default `false`
* `-s` - The path to your encrypted_data_bag_secret file. Default `Chef::Config[:encrypted_data_bag_secret]`
* `-p` - The path to your data bag directory. Default `Chef::Config[:data_bag_path]`

For example to use test data bags with a custom secret file you could run:

`chef exec knife data bag encrypt -w -s /some/path/to/secret -p /custom/data_bags/dir`

#### Flay Wrappers

For convenience, there are equivalent commands added to flay that really just wrap the call to these commands.

* `flay encrypt DATA_BAG ITEM` - Will encrypt the data bag and write to the file
* `flay decrypt DATA_BAG ITEM` - Will decrypt the data bag and write to the file

Both of these support the `--no-write` option to prevent writing the result to the file. There is also the `-t` option,
we sets the secret file and data bag path to `test/integration/encrypted_data_bag_secret` and
`test/integration/data_bags` respectively.

### Testing Encrypted Data Bags

The _test/integration/data_bags_ directory should contain subdirectories for each data bag you want to test (just like 
your chef repo would).

**To create an encrypted data bag item, follow these steps (assuming you're testing ejson/keys):**

* Create `test/integration/data_bags/ejson/keys.json` and add your items
* Run `chef exec flay encrypt ejson keys -t`
* Notice that `test/integration/data_bags/ejson/keys.json` contains the encrypted contents

**Updating a data bag**

* Decrypt the data bag using `chef exec flay decrypt ejson keys -t`
* Notice that `test/integration/data_bags/ejson/keys.json` contains the decrypted contents
* Update the contents as necessary
* Run `chef exec flay encrypt ejson keys -t`
* Notice that `test/integration/data_bags/ejson/keys.json` contains the (updated) encrypted contents

### Cookbook Generation Example

```
$ chef exec flay generate cookbook chef-demo-flay

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

