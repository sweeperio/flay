context          = ChefDK::Generator.context
cookbook_dir     = File.join(context.cookbook_root, context.cookbook_name)
recipe_path      = File.join(cookbook_dir, "recipes", "#{context.new_file_basename}.rb")
spec_helper_path = File.join(cookbook_dir, "test", "unit", "spec_helper.rb")
spec_path        = File.join(cookbook_dir, "test", "unit", "recipes", "#{context.new_file_basename}_spec.rb")

directory("#{cookbook_dir}/test/unit/recipes") { recursive true }

cookbook_file spec_helper_path do
  source "test/unit/spec_helper.rb"
  action :create_if_missing
end

flay_template(recipe_path) { source "recipe.rb.erb" }
flay_template(spec_path) { source "recipe_spec.rb.erb" }
