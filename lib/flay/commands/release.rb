class Flay::Commands::Release < Thor::Group
  include Flay::Helpers
  include Thor::Actions

  ERROR_METADATA = "metadata.rb not found".freeze
  ERROR_GIT      = "There are files that need to be committed before releasing".freeze
  ERROR_VERSION  = "Missing or invalid version in metadata.rb".freeze

  VERSION_MATCH = /^\s*version\s*\(?'?"?([^"']+)"?'?\)?\s*$/.freeze

  def self.register_with(thor, as: "MISSING NAME")
    thor.register(self, as, as, "creates a release for this cookbook")
  end

  def self.exit_on_failure?
    true
  end

  desc "creates a new release and uploads it"

  def fail_fast
    exit 1 unless git_clean? && git_committed?
    exit 1 unless metadata_exists?
    exit 1 if version.nil?
  end

  def berks_install
    say "Installing berks dependencies...", :green
    shell_exec("chef exec berks install")
  end

  def create_tag
    return if tag_exists?
    say "Creating tag for v#{version}...", :green
    shell_exec("git tag -a -m \"Version #{version}\" v#{version}")
  end

  def push_commits_and_tags
    say "Pushing commits and tags...", :green
    fail Thor::Error, "Couldn't push commits" unless shell_exec("git push", show_output: false).last == 0
    fail Thor::Error, "Couldn't push tags" unless shell_exec("git push --tags", show_output: false).last == 0
  end

  def berks_upload
    say "Uploading cookbook to chef server...", :green
    shell_exec("chef exec berks upload --no-ssl-verify")
  end

  private

  def version
    @version ||= begin
      contents = File.read(File.join(Dir.pwd, "metadata.rb"))
      version  = VERSION_MATCH.match(contents)
      return version[1] if version && Gem::Version.correct?(version[1])

      say ERROR_VERSION, :red
      nil
    end
  end

  def metadata_exists?
    found = File.exist?(File.join(Dir.pwd, "metadata.rb"))
    say ERROR_METADATA, :red unless found
    found
  end

  def git_clean?
    status = shell_exec("git diff --exit-code", show_output: false).last
    say ERROR_GIT, :red unless status == 0
    status == 0
  end

  def git_committed?
    status = shell_exec("git diff-index --quiet --cached HEAD", show_output: false).last
    say ERROR_GIT, :red unless status == 0
    status == 0
  end

  def tag_exists?
    tags = shell_exec("git tag").first
    tags.include?("v#{version}")
  end
end
