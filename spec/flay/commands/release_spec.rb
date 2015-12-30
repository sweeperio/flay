describe Flay::Commands::Release, :command do
  COMMANDS = {
    berks_install: "chef exec berks install",
    berks_upload: "chef exec berks upload --no-ssl-verify",
    git_clean: "git diff --exit-code",
    git_committed: "git diff-index --quiet --cached HEAD",
    git_push: "git push",
    git_push_tags: "git push --tags"
  }.freeze

  let(:metadata_path) { File.join(Dir.pwd, "metadata.rb") }

  def invoke
    described_class.new.invoke_all
  end

  def stub(cmd, success: true)
    cli = COMMANDS.fetch(cmd)
    stub_command(cli, result: [cli, "error", success ? 0 : 1])
  end

  def stub_git_tag(version)
    stub_command("git tag -a -m \"Version #{version}\" v#{version}", result: ["success", "", 0])
  end

  def stub_git_tags(*versions)
    result = versions.join("\n")
    stub_command("git tag", result: [result, "", 0])
  end

  def stub_metadata(found: true, version: "0.1.0") # rubocop:disable Metrics/AbcSize
    contents = <<-EOF
    name "mycookbook"
    maintainer "Some user"
    EOF

    contents << "\nversion '#{version}'" unless version.nil? || version.empty?
    allow(File).to receive(:exist?).with(metadata_path).and_return(found)
    allow(File).to receive(:read).with(metadata_path).and_return(contents)
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

  context "on a successful run" do
    commands = %i(git_clean git_committed berks_install git_push git_push_tags berks_upload)

    before(:each) do
      stub_git_tags
      stub_git_tag("0.1.0")
      stub_metadata(version: "0.1.0")

      commands.each(&method(:stub))
      invoke
    end

    commands.map { |cmd| COMMANDS.fetch(cmd) }.each do |cmd|
      it "runs `#{cmd}`" do
        expect(output_lines).to include(cmd)
      end
    end
  end

  context "when metadata.rb is not found or is missing a version" do
    before(:each) do
      stub(:git_clean)
      stub(:git_committed)
    end

    it "raises when metadata not found" do
      stub_metadata(found: false)
      expect { invoke }.to raise_error(Thor::Error, described_class::ERROR_METADATA)
    end

    it "raises when version if not found" do
      stub_metadata(version: nil)
      expect { invoke }.to raise_error(Thor::Error, described_class::ERROR_VERSION)
    end

    it "raises when version is not valid" do
      stub_metadata(version: "abc")
      expect { invoke }.to raise_error(Thor::Error, described_class::ERROR_VERSION)
    end
  end

  context "when git state is not clean" do
    before(:each) do
      stub_metadata
    end

    it "raises when there are unstaged changes" do
      stub(:git_clean, success: false)
      expect { invoke }.to raise_error(Thor::Error, described_class::ERROR_GIT)
      expect(output_lines).to include("error")
    end

    it "raises when there are uncommitted changes" do
      stub(:git_clean)
      stub(:git_committed, success: false)
      expect { invoke }.to raise_error(Thor::Error, described_class::ERROR_GIT)
      expect(output_lines).to include("error")
    end
  end
end
