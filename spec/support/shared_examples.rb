shared_examples "a registered command" do
  let(:command) { described_class.commands[command_name] }

  it "defines the command" do
    expect(command).to_not be_nil
    expect(command.name).to eq(command_name)
  end

  it "sets the description" do
    expect(command.description).to be
    expect(command.description).to_not be_empty
  end

  it "sets the usage string" do
    expect(command.usage).to be
    expect(command.usage).to_not be_empty
  end
end

shared_examples "a command" do
  let(:command) { described_class.commands[command_name] }

  it "defines the command" do
    expect(command).to_not be_nil
    expect(command.name).to eq(command_name)
  end

  it "sets the description" do
    expect(command.description).to be
    expect(command.description).to_not be_empty
  end

  it "sets the long description" do
    expect(command.long_description).to be
    expect(command.long_description).to_not be_empty
  end
end

shared_examples "a data bag command" do
  context "command options" do
    it "includes data_bag_path option" do
      option = described_class.options.fetch(:data_bag_path)
      expect(option.fetch(:short)).to eq("-p")
      expect(option.fetch(:long)).to eq("--path")
    end

    it "includes secret_file option" do
      option = described_class.options.fetch(:secret_file)
      expect(option.fetch(:short)).to eq("-s")
      expect(option.fetch(:long)).to eq("--secret-file")
    end

    it "includes write option" do
      option = described_class.options.fetch(:write)
      expect(option.fetch(:short)).to eq("-w")
      expect(option.fetch(:long)).to eq("--write")
      expect(option.fetch(:boolean)).to eq(true)
      expect(option.fetch(:default)).to eq(false)
    end
  end

  shared_examples "a data bag processor" do
    it "displays the processed data bag" do
      expect(command).to receive(:format_for_display)
      expect(command).to receive(:output)
      command.run
    end

    it "when write is true, writes the processed data bag to the file and displays it" do
      command.config[:write] = true

      file = double
      expect(file).to receive(:write)
      expect(File).to receive(:open).with(data_bag_item_path, "w").and_yield(file)

      expect(command).to receive(:format_for_display)
      expect(command).to receive(:output)
      command.run
    end
  end

  context "when defaults are used" do
    around(:each) do |example|
      Chef::Config[:data_bag_path]             = data_bag_path
      Chef::Config[:encrypted_data_bag_secret] = data_bag_secret

      example.run
      Chef::Config.reset
    end

    it_behaves_like "a data bag processor"
  end

  context "when options are supplied" do
    before(:each) do
      command.config[:data_bag_path] = data_bag_path
      command.config[:secret_file]   = data_bag_secret
    end

    it_behaves_like "a data bag processor"
  end
end
