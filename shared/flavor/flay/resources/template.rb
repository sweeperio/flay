default_action :create_if_missing

property :name, String, name_property: true
property :source, String

action :create do
  template new_resource.name do
    source new_resource.source
    helpers ChefDK::Generator::TemplateHelper
    helpers Flay::Context::Helper
  end
end

action :create_if_missing do
  template new_resource.name do
    source new_resource.source
    helpers ChefDK::Generator::TemplateHelper
    helpers Flay::Context::Helper
    action :create_if_missing
  end
end
