module Flay # rubocop:disable Style/ClassAndModuleChildren
  class Cookbook
    PREFIX    = "chef-".freeze
    NAMESPACE = "swpr_".freeze
    PATTERN   = /\A(#{PREFIX})?(#{NAMESPACE})?(.*)\z/.freeze

    attr_reader :prefix, :namespace, :name

    def initialize(name)
      match      = PATTERN.match(name)
      @prefix    = match[1] || PREFIX
      @namespace = match[2] || NAMESPACE
      @name      = match[3]
    end

    def cookbook_name
      @cookbook_name ||= "#{namespace}#{name}"
    end

    def directory_name
      @directory_name ||= "#{prefix}#{namespace}#{name}"
    end
  end
end
