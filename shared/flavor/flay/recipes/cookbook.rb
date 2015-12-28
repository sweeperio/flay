context      = ChefDK::Generator.context
cookbook_dir = File.join(context.cookbook_root, context.cookbook_name)

# cookbook root dir
directory cookbook_dir

# metadata.rb
template "#{cookbook_dir}/metadata.rb" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Rakefile
cookbook_file "#{cookbook_dir}/Rakefile"

# rubocop
cookbook_file "#{cookbook_dir}/.rubocop.yml" do
  source "rubocop.yml"
end

# travis
cookbook_file "#{cookbook_dir}/.travis.yml" do
  source "travis.yml"
end

# README
template "#{cookbook_dir}/README.md" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# chefignore
cookbook_file "#{cookbook_dir}/chefignore"

if context.use_berkshelf
  # Berks
  cookbook_file "#{cookbook_dir}/Berksfile" do
    action :create_if_missing
  end
else
  # Policyfile
  template "#{cookbook_dir}/Policyfile.rb" do
    source "Policyfile.rb.erb"
    helpers(ChefDK::Generator::TemplateHelper)
  end
end

# TK & Serverspec
template "#{cookbook_dir}/.kitchen.yml" do
  source_file = context.use_berkshelf ? "kitchen.yml.erb" : "kitchen_policyfile.yml.erb"
  source source_file

  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

directory "#{cookbook_dir}/test/integration/default/serverspec" do
  recursive true
end

directory "#{cookbook_dir}/test/integration/helpers/serverspec" do
  recursive true
end

cookbook_file "#{cookbook_dir}/test/integration/helpers/serverspec/spec_helper.rb" do
  source "serverspec_spec_helper.rb"
  action :create_if_missing
end

template "#{cookbook_dir}/test/integration/default/serverspec/default_spec.rb" do
  source "serverspec_default_spec.rb.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

cookbook_file "#{cookbook_dir}/test/integration/encrypted_data_bag_secret" do
  source "encrypted_data_bag_secret"
end

directory "#{cookbook_dir}/test/integration/data_bags/ejson" do
  recursive true
end

cookbook_file "#{cookbook_dir}/test/integration/data_bags/ejson/keys.json" do
  source "keys.json"
end

cookbook_file "#{cookbook_dir}/test/integration/data_bags/ejson/keys.plaintext.json" do
  source "keys.plaintext.json"
end

# Chefspec
cookbook_file "#{cookbook_dir}/.rspec" do
  source "rspec"
end

directory "#{cookbook_dir}/test/unit/recipes" do
  recursive true
end

cookbook_file "#{cookbook_dir}/test/unit/spec_helper.rb" do
  source_file context.use_berkshelf ? "spec_helper.rb" : "spec_helper_policyfile.rb"
  source source_file

  action :create_if_missing
end

template "#{cookbook_dir}/test/unit/recipes/default_spec.rb" do
  source "recipe_spec.rb.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Recipes

directory "#{cookbook_dir}/recipes"

template "#{cookbook_dir}/recipes/default.rb" do
  source "recipe.rb.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# git
if context.have_git
  unless context.skip_git_init
    execute("initialize-git") do
      command("git init .")
      cwd cookbook_dir
    end
  end

  cookbook_file "#{cookbook_dir}/.gitignore" do
    source "gitignore"
  end
end
