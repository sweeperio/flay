class Flay::Config
  DEFAULT_MAINTAINER = "COMPANY_NAME".freeze
  DEFAULT_EMAIL      = "YOUR_EMAIL".freeze
  DEFAULT_LICENSE    = "all_rights".freeze

  attr_reader :maintainer, :email, :license

  class << self
    def parse(yaml_string)
      new(YAML.load(yaml_string))
    end

    def load(yaml_file)
      parse(File.read(yaml_file))
    end

    def current
      paths = search_paths.select(&method(:exist?))
      paths.reduce(new) { |running, config| running.merge(load(config)) }
    end

    private

    def search_paths
      paths = []
      Pathname(Dir.pwd).ascend do |path|
        paths << File.join(path, ".flay.yml")
        break if path.to_s == Dir.home
      end

      paths.reverse
    end

    def exist?(path)
      ::File.exist?(path)
    end
  end

  def initialize(options = {})
    @maintainer = options.fetch("maintainer", DEFAULT_MAINTAINER)
    @email      = options.fetch("email", DEFAULT_EMAIL)
    @license    = options.fetch("license", DEFAULT_LICENSE)
  end

  def merge(other_config)
    overrides = other_config.to_hash.reject do |_, value|
      [DEFAULT_MAINTAINER, DEFAULT_EMAIL, DEFAULT_LICENSE].include?(value)
    end

    self.class.new(to_hash.merge(overrides))
  end

  def to_hash
    { "maintainer" => maintainer, "email" => email, "license" => license }
  end
end
