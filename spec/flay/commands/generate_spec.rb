describe Flay::Commands::Generate do
  let(:command) { described_class.commands[command_name] }

  def invoke_command(*args)
    described_class.new.invoke(command_name, args)
  end

  def stub_command(command, result: ["out", "error", 0])
    expect(Open3).to receive(:capture3).with(command).and_return(result)
  end

  context ".register_with" do
    it "registers itself with the specified Thor" do
      thor = spy("Thor")
      described_class.register_with(thor, as: "test")

      expect(thor).to have_received(:register).with(
        described_class,
        "test",
        "test TYPE NAME",
        "generate a cookbook/recipe"
      )
    end
  end

  describe "#cookbook", :command do
    let(:command_name) { "cookbook" }
    it_behaves_like "a command"

    it "sets the usage string appropriately" do
      expect(command.usage).to eq("cookbook NAME")
    end

    context "when run successfully" do
      before { stub_command("chef generate cookbook test") }

      it "generates a cookbook using the ChefDK and prints the output" do
        invoke_command("test")
        expect(stdout).to eq("out")
      end
    end

    context "when an error occurs" do
      before { stub_command("chef generate cookbook test", result: ["out", "error", 1]) }

      it "prints both stdout and stderr" do
        invoke_command("test")
        expect(output_lines).to eq(%w(out error))
      end
    end
  end

  describe "#recipe", :command do
    let(:command_name) { "recipe" }
    it_behaves_like "a command"

    it "sets the usage string appropriately" do
      expect(command.usage).to eq("recipe NAME")
    end

    context "when run successfully" do
      before { stub_command("chef generate recipe test") }

      it "generates a recipe using the ChefDK and prints the output" do
        invoke_command("test")
        expect(stdout).to eq("out")
      end
    end

    context "when an error occurs" do
      before { stub_command("chef generate recipe test", result: ["out", "error", 1]) }

      it "prints both stdout and stderr" do
        invoke_command("test")
        expect(output_lines).to eq(%w(out error))
      end
    end
  end
end
