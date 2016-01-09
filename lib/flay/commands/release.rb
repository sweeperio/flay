class Flay::Commands::Release < Thor::Group
  include Flay::Helpers
  include Thor::Actions

  ERROR_METADATA = "metadata.rb file not found in current repo".freeze
  ERROR_GIT      = "There are files that need to be committed before releasing".freeze
  ERROR_VERSION  = "Missing or invalid version in metadata.rb".freeze

  VERSION_MATCH = /^\s*version\s*\(?'?"?([^"']+)"?'?\)?\s*$/.freeze

  def self.register_with(thor, as: "MISSING NAME")
    thor.register(self, as, as, "creates a release for this cookbook")
  end

  desc "creates a new release and uploads it"

  def fail_fast
    exit 1 unless git_repo? && git_clean? && git_committed?
    exit 1 if version.nil?
  end

  def berks_install
    say "Installing berks dependencies...", :green
    shell_exec("chef exec berks install")
  end

  def create_tag
    say "Tag for v#{version} already exists!", :green && return if tag_exists?
    say "Creating tag for v#{version}...", :green
    shell_exec("git tag -a -m \"Version #{version}\" v#{version}")
  end

  def push_commits_and_tags
    say "Pushing commits and tags...", :green
    exit 1 unless shell_exec_quiet("git push", error_message: "Couldn't push commits")
    exit 1 unless shell_exec_quiet("git push --tags", error_message: "Couldn't push tags")
  end

  def berks_upload
    say "Uploading cookbook to chef server...", :green
    shell_exec("chef exec berks upload")
  end

  def all_done
    say "Done! Version v#{version} pushed to git remote and chef server.", :green
  end

  private

  def version
    return nil unless metadata_exists?

    @version ||= begin
      contents = File.read(metadata_path)
      version  = VERSION_MATCH.match(contents)
      return version[1] if version && Gem::Version.correct?(version[1])

      say ERROR_VERSION, :red
      nil
    end
  end

  def metadata_exists?
    path = metadata_path
    say ERROR_METADATA, :red unless path && File.exist?(path)
    path && File.exist?(path)
  end

  def git_repo?
    return true unless git_root.nil?
    say ERROR_GIT, :red
    false
  end

  def git_clean?
    shell_exec_quiet("git diff --exit-code", error_message: ERROR_GIT)
  end

  def git_committed?
    shell_exec_quiet("git diff-index --quiet --cached HEAD", error_message: ERROR_GIT)
  end

  def tag_exists?
    tags = shell_exec("git tag").first
    tags.include?("v#{version}")
  end
end
