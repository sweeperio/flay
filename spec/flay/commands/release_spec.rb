describe Flay::Commands::Release, :command, :shell_commands do
  let(:shell_commands) do
    {
      berks_install: ["chef exec berks install", "", ""],
      berks_upload: ["chef exec berks upload --except=test integration", "", ""],
      git_root: ["git rev-parse --show-toplevel", Dir.pwd, ""],
      git_clean: ["git diff --exit-code", "", ""],
      git_committed: ["git diff-index --quiet --cached HEAD", "", ""],
      git_push: ["git push", "", ""],
      git_push_tags: ["git push --tags", "", ""],
      git_tag: ["git tag", "", ""],
      git_tag_create: ["git tag -a -m \"Version 0.1.0\" v0.1.0", "", ""]
    }
  end

  context ".register_with" do
    it "registers itself with the specified Thor" do
      thor = spy("Thor")
      described_class.register_with(thor, as: "test")

      expect(thor).to have_received(:register).with(
        described_class,
        "test",
        "test",
        "creates a release for this cookbook"
      )
    end
  end

  context "when successful" do
    before(:each) do
      shell_commands.keys.each(&method(:stub_shell_command))
      stub_metadata(:metadata)
    end

    it "doesn't raise or exit" do
      expect { invoke }.to_not raise_error
    end

    it "lets the caller know what's happening" do
      invoke

      expect(output_lines).to include("Installing berks dependencies...")
      expect(output_lines).to include("Creating tag for v0.1.0...")
      expect(output_lines).to include("Pushing commits and tags...")
      expect(output_lines).to include("Uploading cookbook to chef server...")
      expect(output_lines).to include("Done! Version v0.1.0 pushed to git remote and chef server.")
    end
  end

  context "when metadata.rb is not found or is missing a version" do
    before(:each) do
      %i(git_root git_clean git_committed).each(&method(:stub_shell_command))
    end

    it "exits with 1 when metadata.rb not found" do
      expect(command).to receive(:metadata_path).and_return(nil)
      expect { invoke }.to exit_with_code(1)
      expect(output_lines).to include(described_class::ERROR_METADATA)
    end

    it "exits with 1 when version not found" do
      stub_metadata(:metadata_no_version)
      expect { invoke }.to exit_with_code(1)
      expect(output_lines).to include(described_class::ERROR_VERSION)
    end

    it "exits with 1 when version is not valid" do
      stub_metadata(:metadata_bad_version)
      expect { invoke }.to exit_with_code(1)
      expect(output_lines).to include(described_class::ERROR_VERSION)
    end
  end

  context "when not a git repo" do
    it "exits with 1" do
      stub_shell_command(:git_root, status: 1)
      expect { invoke }.to exit_with_code(1)
      expect(output_lines).to include(described_class::ERROR_GIT)
    end
  end

  context "when git state is not clean" do
    before(:each) do
      stub_shell_command(:git_root)
      stub_metadata(:metadata)
    end

    it "exits with 1 when there are unstaged changes" do
      stub_shell_command(:git_clean, status: 1)
      expect { invoke }.to exit_with_code(1)
    end

    it "exits with 1 when there are uncommitted changes" do
      stub_shell_command(:git_clean)
      stub_shell_command(:git_committed, status: 1)
      expect { invoke }.to exit_with_code(1)
    end
  end
end
