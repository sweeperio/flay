module ChefGen
  module Flavor
    class Flay
      NAME    = "flay".freeze
      DESC    = "Generate a new cookbook with **better** defaults".freeze
      VERSION = Gem.loaded_specs["chef-flavor-flay"].version.to_s.freeze

      attr_reader :temp_path

      def initialize(temp_path: nil)
        @temp_path = temp_path
      end

      def add_content
        FileUtils.cp_r(File.expand_path(flavor_cookbook_path) + "/.", temp_path)
      end

      private

      def flavor_cookbook_path
        File.join(File.dirname(__FILE__), "..", "..", "..", "shared", "flavor", NAME)
      end
    end
  end
end
