module Flay # rubocop:disable Style/ClassAndModuleChildren
  class Context < SimpleDelegator
    alias_method :context, :__getobj__

    def self.current
      @current ||= Context.new(ChefDK::Generator.context)
    end

    module Helper
      extend Forwardable

      delegate %i(cookbook_name directory_name) => :flay_cookbook

      private

      def flay_cookbook
        @flay_cookbook ||= Flay::Cookbook.new(ChefDK::Generator.context.cookbook_name)
      end
    end

    include Helper
  end
end
