describe Flay::CLI do
  it "sets the package name" do
    name = described_class.instance_variable_get("@package_name")
    expect(name).to eq("flay")
  end

  context "#generate" do
    let(:command_name) { "generate" }
    it_behaves_like "a registered command"

    it "includes arguments in usage string" do
      command = described_class.commands[command_name]
      expect(command.usage).to eq("generate TYPE NAME")
    end
  end

  context "#release" do
    let(:command_name) { "release" }
    it_behaves_like "a registered command"
  end

  context "#link", :command do
    let(:command_name) { "link" }
    it_behaves_like "a command"

    it "creates a symlink for .chef to default target" do
      expect_any_instance_of(described_class).to receive(:create_link).with(
        File.join(Dir.pwd, ".chef"),
        "#{File.expand_path('~/.chef-sweeper')}/"
      )

      invoke
    end

    it "uses --chef-path option as target when supplied" do
      expect_any_instance_of(described_class).to receive(:create_link).with(
        File.join(Dir.pwd, ".chef"),
        "/spec/.chef/"
      )

      described_class.start(%w(link --chef-path=/spec/.chef/))
    end

    it "will ensure the symlink links directories" do
      expect_any_instance_of(described_class).to receive(:create_link).with(
        File.join(Dir.pwd, ".chef"),
        "/spec/.chef/"
      )

      described_class.start(%w(link --chef-path=/spec/.chef))
    end
  end

  context "#version", :command do
    let(:command_name) { "version" }
    it_behaves_like "a command"

    it "displays the current version" do
      invoke
      expect(stdout).to eq("flay version: #{Flay::VERSION}")
    end
  end
end
