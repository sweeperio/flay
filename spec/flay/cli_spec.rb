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

  context "#encrypt", :command do
    let(:command_name) { "encrypt" }
    it_behaves_like "a command"

    it "encrypts the data bag using knife" do
      expect_any_instance_of(described_class).to receive(:shell_exec).with(
        "chef exec knife data bag encrypt users test -w"
      )

      described_class.start(%w(encrypt users test))
    end

    it "doesn't write the file if --no-write is specified" do
      expect_any_instance_of(described_class).to receive(:shell_exec).with(
        "chef exec knife data bag encrypt users test"
      )

      described_class.start(%w(encrypt users test --no-write))
    end

    it "uses test settings when `-t` supplied" do
      args = "-w -s test/integration/encrypted_data_bag_secret -p test/integration/data_bags"
      expect_any_instance_of(described_class).to receive(:shell_exec).with(
        "chef exec knife data bag encrypt users test #{args}"
      )

      described_class.start(%w(encrypt users test -t))
    end
  end

  context "#decrypt", :command do
    let(:command_name) { "encrypt" }
    it_behaves_like "a command"

    it "decrypts the data bag using knife" do
      expect_any_instance_of(described_class).to receive(:shell_exec).with(
        "chef exec knife data bag decrypt users test -w"
      )

      described_class.start(%w(decrypt users test))
    end

    it "doesn't write the file if --no-write is specified" do
      expect_any_instance_of(described_class).to receive(:shell_exec).with(
        "chef exec knife data bag decrypt users test"
      )

      described_class.start(%w(decrypt users test --no-write))
    end

    it "uses test settings when `-t` supplied" do
      args = "-w -s test/integration/encrypted_data_bag_secret -p test/integration/data_bags"
      expect_any_instance_of(described_class).to receive(:shell_exec).with(
        "chef exec knife data bag decrypt users test #{args}"
      )

      described_class.start(%w(decrypt users test -t))
    end
  end
end
