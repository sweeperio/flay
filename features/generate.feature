Feature: chef generate cookbook

  Verifies that `chef generate cookbook` works when the path is chosen
  by `chef-gen-flavors`

  Background:
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value    |
      |----------------|----------|
      | CHEFGEN_FLAVOR | flay     |
    When I generate a cookbook named "foo"
    Then the exit status should be 0
    And I cd to "foo"

  Scenario: expected cookbook files are created
    Then the following files should exist:
      | .bundle/config                                       |
      | .gitignore                                           |
      | .kitchen.yml                                         |
      | .rspec                                               |
      | .rubocop.yml                                         |
      | .travis.yml                                          |
      | Berksfile                                            |
      | chefignore                                           |
      | Gemfile                                              |
      | metadata.rb                                          |
      | Rakefile                                             |
      | README.md                                            |
      | recipes/default.rb                                   |
      | test/integration/data_bags/ejson/keys.json           |
      | test/integration/data_bags/ejson/keys.plaintext.json |
      | test/integration/default/serverspec/default_spec.rb  |
      | test/integration/encrypted_data_bag_secret           |
      | test/integration/helpers/serverspec/spec_helper.rb   |
      | test/unit/recipes/default_spec.rb                    |
      | test/unit/spec_helper.rb                             |

  Scenario: rake tasks are available
    When I bundle install
    And I list the rake tasks
    Then the exit status should be 0
    And the output should match each of:
      | ^rake encrypt_data_bag |
      | ^rake rubocop          |
      | ^rake spec             |

  Scenario: generated cookbook passes rubocop
    When I bundle install
    And I run the "rubocop" rake task
    Then the exit status should be 0
