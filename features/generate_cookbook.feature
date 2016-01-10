Feature: chef generate cookbook

  Verifies that `chef generate cookbook` works when the path is chosen
  by `chef-gen-flavors`

  Background:
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variable "CHEFGEN_FLAVOR" to "flay"
    When I generate a cookbook named "foo"
    Then the exit status should be 0
    And I cd to "chef-swpr_foo"

  Scenario: expected cookbook files are created
    Then the following files should exist:
      | .gitignore                                           |
      | .kitchen.yml                                         |
      | .rspec                                               |
      | .rubocop.yml                                         |
      | .travis.yml                                          |
      | Berksfile                                            |
      | chefignore                                           |
      | CODE_OF_CONDUCT.md                                   |
      | CONTRIBUTING.md                                      |
      | LICENSE                                              |
      | metadata.rb                                          |
      | Rakefile                                             |
      | README.md                                            |
      | recipes/default.rb                                   |
      | test/chef/knife.rb                                   |
      | test/chef/client.enc                                 |
      | test/integration/data_bags/ejson/keys.json           |
      | test/integration/default/serverspec/default_spec.rb  |
      | test/integration/encrypted_data_bag_secret           |
      | test/integration/helpers/serverspec/spec_helper.rb   |
      | test/unit/recipes/default_spec.rb                    |
      | test/unit/spec_helper.rb                             |

  Scenario: cookbook_name in templates includes swpr_ prefix
    Then the file "README.md" should contain "# swpr_foo"
    And the file "metadata.rb" should match /^name\s*"swpr_foo"/

  Scenario: rake tasks are available
    When I bundle install
    And I list the rake tasks
    Then the exit status should be 0
    And the output should match each of:
      | ^rake foodcritic           |
      | ^rake rubocop              |
      | ^rake rubocop:auto_correct |
      | ^rake spec                 |
      | ^rake style                |
      | ^rake test                 |

  Scenario: generated cookbook passes style tests
    When I bundle install
    And I run rake style
    Then the exit status should be 0
