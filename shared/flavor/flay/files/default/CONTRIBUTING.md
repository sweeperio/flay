# Contributing

First off, glad you're here and want to contribute! :heart:

## Getting Started

You'll need to have the [chefdk] and [vagrant] installed to work on this repo. For installation and setup details,
check out the links.

## Making Changes

* If necessary, [fork this repo]
* Create a branch off of master
* Make focused commits with descriptive messages
* Add tests that will fail without your code, and pass with it
* Push your branch and submit a pull request indicating the problem you're addressing and the solution you're proposing
* **Ping someone on the PR!** - Most of us only get notifications if we're pinged directly

### Running Tests

* Style (rubocop/foodcritic) - `chef exec rake style`
* RSpec/ChefSpec - `chef exec rake rspec`
* Style and Specs - `chef exec rake`
* Integration Tests (Test Kitchen) - `chef exec kitchen test`

Generally, during development, it's faster to run `chef exec kitchen converge && chef exec kitchen verify` after each 
change. That's totally cool, just be sure to run a clean test with `chef exec kitchen test` before submitting a PR.

#### Tip

If you get sick of typing `chef exec` in front of these commands, you can run `eval "$(chef shell-init SHELL)"` to 
update your current shell to use the [chefdk] by default (you can remove `chef exec` from all these).

[chefdk]: https://downloads.chef.io/chef-dk/
[vagrant]: https://www.vagrantup.com/
[fork this repo]: https://help.github.com/articles/fork-a-repo
