describe Flay::Commands::Release, :command do
  let(:known_commands) do
    {
      berks_install: "chef exec berks install",
      berks_upload: "chef exec berks upload --no-ssl-verify",
      git_clean: "git diff --exit-code",
      git_committed: "git diff-index --quiet --cached HEAD",
      git_push: "git push",
      git_push_tags: "git push --tags"
    }
  end

  let(:metadata_path) { File.join(Dir.pwd, "metadata.rb") }

  def invoke
    described_class.new.invoke_all
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
      stub_git_tags
      stub_git_tag("0.1.0")
      stub_metadata(version: "0.1.0")

      %i(
        git_clean
        git_committed
        berks_install
        git_push
        git_push_tags
        berks_upload
      ).each(&method(:stub_known_command))
    end

    it "doesn't raise or exit" do
      expect { invoke }.to_not raise_error
    end
  end

  context "when metadata.rb is not found or is missing a version" do
    before(:each) do
      stub_known_command(:git_clean)
      stub_known_command(:git_committed)
    end

    it "exits with 1 when metadata not found" do
      stub_metadata(found: false)
      expect { invoke }.to exit_with_code(1)
      expect(output_lines).to include(described_class::ERROR_METADATA)
    end

    it "exits with 1 when version not found" do
      stub_metadata(version: nil)
      expect { invoke }.to exit_with_code(1)
      expect(output_lines).to include(described_class::ERROR_VERSION)
    end

    it "exits with 1 when version is not valid" do
      stub_metadata(version: "abc")
      expect { invoke }.to exit_with_code(1)
      expect(output_lines).to include(described_class::ERROR_VERSION)
    end
  end

  context "when git state is not clean" do
    before(:each) do
      stub_metadata
    end

    it "exits with 1 when there are unstaged changes" do
      stub_known_command(:git_clean, success: false)
      expect { invoke }.to exit_with_code(1)
      expect(output_lines).to include(described_class::ERROR_GIT)
    end

    it "exits with 1 when there are uncommitted changes" do
      stub_known_command(:git_clean)
      stub_known_command(:git_committed, success: false)
      expect { invoke }.to exit_with_code(1)
      expect(output_lines).to include(described_class::ERROR_GIT)
    end
  end
end
