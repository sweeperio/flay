Feature: chef generate recipe

  Verifies that `chef generate recipe` works as expected

  Background:
    Given an empty directory named "chef-swpr_foo/recipes"
    When I cd to "chef-swpr_foo"
    And I generate a recipe named "test"

  Scenario: expected files are created
    Then the following files should exist:
      | recipes/test.rb                |
      | test/unit/recipes/test_spec.rb |
      | test/unit/spec_helper.rb       |

  Scenario: recipe contains header comments
    Then the file "recipes/test.rb" should contain "# Cookbook Name:: swpr_foo"
    And the file "recipes/test.rb" should contain "# Recipe:: test"

  Scenario: spec contains header comments
    Then the file "test/unit/recipes/test_spec.rb" should contain "# Cookbook Name:: swpr_foo"
    And the file "test/unit/recipes/test_spec.rb" should contain "# Spec:: test"

  Scenario: spec file contains basic plumbing
    Then the file "test/unit/recipes/test_spec.rb" should contain
    """
    describe "swpr_foo::test" do
      cached(:chef_run) do
        runner = ChefSpec::SoloRunner.new
        runner.converge(described_recipe)
      end

      it "converges successfully" do
        expect { chef_run }.to_not raise_error
      end
    end
    """
