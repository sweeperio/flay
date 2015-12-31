describe Flay::Commands::Generate, :shell_commands do
  let(:subcommand) { described_class.commands[command_name] }

  let(:shell_commands) do
    {
      generate_cookbook: ["chef generate cookbook test #{described_class::ARGS}", "out", "error"],
      generate_recipe: ["chef generate recipe test #{described_class::ARGS}", "out", "error"]
    }
  end

  context ".register_with" do
    it "registers itself with the specified Thor" do
      thor = spy("Thor")
      described_class.register_with(thor, as: "test")

      expect(thor).to have_received(:register).with(
        described_class,
        "test",
        "test TYPE NAME",
        "generate a cookbook/recipe using flay defaults"
      )
    end
  end

  describe "#cookbook", :command do
    let(:command_name) { "cookbook" }
    it_behaves_like "a command"

    it "sets the usage string appropriately" do
      expect(subcommand.usage).to eq("cookbook NAME")
    end

    context "when run successfully" do
      before(:each) { stub_shell_command(:generate_cookbook) }

      it "generates a cookbook using the ChefDK and prints the output" do
        invoke("test")
        expect(stdout).to eq("out")
      end
    end

    context "when an error occurs" do
      before(:each) { stub_shell_command(:generate_cookbook, status: 1, include_both: true) }

      it "prints both stdout and stderr" do
        invoke("test")
        expect(output_lines).to eq(%w(out error))
      end
    end
  end

  describe "#recipe", :command do
    let(:command_name) { "recipe" }
    it_behaves_like "a command"

    it "sets the usage string appropriately" do
      expect(subcommand.usage).to eq("recipe NAME")
    end

    context "when run successfully" do
      before(:each) { stub_shell_command(:generate_recipe) }

      it "generates a recipe using the ChefDK and prints the output" do
        invoke("test")
        expect(stdout).to eq("out")
      end
    end

    context "when an error occurs" do
      before(:each) { stub_shell_command(:generate_recipe, status: 1, include_both: true) }

      it "prints both stdout and stderr" do
        invoke("test")
        expect(output_lines).to eq(%w(out error))
      end
    end
  end
end
