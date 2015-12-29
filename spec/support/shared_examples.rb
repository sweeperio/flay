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
