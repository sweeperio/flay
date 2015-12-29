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
end
