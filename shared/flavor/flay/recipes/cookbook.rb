context      = ChefDK::Generator.context
cookbook_dir = File.join(context.cookbook_root, context.cookbook_name)
kitchen_dir  = File.join(cookbook_dir, "test", "integration")

# Common Cookbook Things
directory cookbook_dir
directory "#{cookbook_dir}/.bundle"
directory "#{cookbook_dir}/recipes"

cookbook_file("#{cookbook_dir}/.gitignore") { source "gitignore" }
cookbook_file("#{cookbook_dir}/.rubocop.yml") { source "rubocop.yml" }
cookbook_file("#{cookbook_dir}/Berksfile") { action :create_if_missing }
cookbook_file "#{cookbook_dir}/chefignore"
cookbook_file "#{cookbook_dir}/Rakefile"

flay_template "#{cookbook_dir}/metadata.rb"
flay_template "#{cookbook_dir}/README.md"

# ChefSpec
directory("#{cookbook_dir}/test/chef") { recursive true }
directory("#{cookbook_dir}/test/unit/recipes") { recursive true }

cookbook_file("#{cookbook_dir}/.rspec") { source "rspec" }
cookbook_file("#{cookbook_dir}/.travis.yml") { source "travis.yml" }
cookbook_file("#{cookbook_dir}/test/chef/client.enc") { source "test/chef/client.enc" }
cookbook_file("#{cookbook_dir}/test/chef/knife.rb") { source "test/chef/knife.rb" }

cookbook_file "#{cookbook_dir}/test/unit/spec_helper.rb" do
  source "test/unit/spec_helper.rb"
  action :create_if_missing
end

flay_template("#{cookbook_dir}/recipes/default.rb") { source "recipe.rb.erb" }
flay_template("#{cookbook_dir}/test/unit/recipes/default_spec.rb") { source "recipe_spec.rb.erb" }

# Test Kitchen
directory("#{kitchen_dir}/data_bags/ejson") { recursive true }
directory("#{kitchen_dir}/default/serverspec") { recursive true }
directory("#{kitchen_dir}/helpers/serverspec") { recursive true }

cookbook_file("#{kitchen_dir}/encrypted_data_bag_secret") do
  source "test/integration/encrypted_data_bag_secret"
end

cookbook_file("#{kitchen_dir}/data_bags/ejson/keys.json") do
  source "test/integration/data_bags/ejson/keys.json"
end

cookbook_file("#{kitchen_dir}/data_bags/ejson/keys.plaintext.json") do
  source "test/integration/data_bags/ejson/keys.plaintext.json"
end

cookbook_file "#{kitchen_dir}/helpers/serverspec/spec_helper.rb" do
  source "test/integration/helpers/serverspec/spec_helper.rb"
  action :create_if_missing
end

flay_template("#{cookbook_dir}/.kitchen.yml") { source "kitchen.yml.erb" }

flay_template "#{kitchen_dir}/default/serverspec/default_spec.rb" do
  source "serverspec_default_spec.rb.erb"
end

# git
if context.have_git && !context.skip_git_init
  execute("initialize-git") do
    command("git init .")
    cwd cookbook_dir
  end
end
