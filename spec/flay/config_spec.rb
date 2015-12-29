describe Flay::Config do
  let(:default_config) { YAML.load_file(fixture_path(".flay.yml")) }

  matcher :match_config do |config|
    match do |actual|
      config ||= default_config

      expect(actual.maintainer).to eq(config["maintainer"])
      expect(actual.email).to eq(config["email"])
      expect(actual.license).to eq(config["license"])
    end
  end

  describe "initialization and equality" do
    context "with defaults" do
      let(:config) { described_class.new }

      it "uses default values for config" do
        expected = {
          "maintainer" => described_class::DEFAULT_MAINTAINER,
          "email"      => described_class::DEFAULT_EMAIL,
          "license"    => described_class::DEFAULT_LICENSE
        }

        expect(config).to match_config(expected)
      end
    end

    context "with valid configuration supplied" do
      let(:config) { described_class.new(YAML.load(read_fixture(".flay.yml"))) }

      it "reads in configuration values" do
        expect(config).to match_config
      end
    end

    it "#to_hash returns a hash of the config values" do
      config = described_class.load(fixture_path(".flay.yml"))
      expect(config.to_hash).to be_kind_of(Hash)
      expect(config.to_hash.fetch("maintainer")).to eq(config.maintainer)
      expect(config.to_hash.fetch("email")).to eq(config.email)
      expect(config.to_hash.fetch("license")).to eq(config.license)
    end
  end

  describe "parsing and loading files" do
    it ".parse creates a config object from a YAML string" do
      config = described_class.parse(read_fixture(".flay.yml"))
      expect(config).to match_config
    end

    it ".load creates a config object from a YAML file" do
      config = described_class.load(fixture_path(".flay.yml"))
      expect(config).to match_config
    end
  end

  describe "merging configs" do
    let(:original) { described_class.load(fixture_path(".flay.yml")) }

    it "overrides values" do
      values = { "maintainer" => "me", "email" => "test", "license" => "gplv3" }
      config = original.merge(described_class.new(values))
      expect(config).to match_config(values)
    end

    it "only overrides supplied values" do
      values = { "email" => "new@email.com" }
      config = original.merge(described_class.new(values))

      expect(config.maintainer).to eq(original.maintainer)
      expect(config.license).to eq(original.license)
      expect(config.email).to eq(values.fetch("email"))
    end
  end

  describe ".current" do
    let(:home) { File.expand_path("../../fixtures", __FILE__) }
    let(:pwd) { File.expand_path("../../fixtures/sub/dir", __FILE__) }
    let(:current) { described_class.current }

    it "merges configs from $HOME to the current directory" do
      allow(Dir).to receive(:pwd).and_return(pwd)
      allow(Dir).to receive(:home).and_return(home)

      expect(current.maintainer).to eq("Flayer")               # PWD/sub/dir/.flay.yml
      expect(current.email).to eq("overridden@email.com")      # PWD/sub/.flay.yml
      expect(current.license).to eq(default_config["license"]) # PWD/.flay.yml
    end
  end
end
