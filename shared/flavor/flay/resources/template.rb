default_action :create_if_missing

property :name, String, name_property: true
property :source, String
property :use_helpers, [TrueClass, FalseClass], default: true

action :create do
  template new_resource.name do
    source new_resource.source
    helpers new_resource.helpers
  end
end

action :create_if_missing do
  template new_resource.name do
    source new_resource.source
    helpers new_resource.helpers
    action :create_if_missing
  end
end

def helpers
  use_helpers ? ChefDK::Generator::TemplateHelper : []
end
