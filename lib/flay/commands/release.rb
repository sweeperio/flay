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

  desc "creates a new release and uploads it"

  def fail_fast
    fail Thor::Error, ERROR_GIT unless git_clean? && git_committed?
    fail Thor::Error, ERROR_METADATA unless metadata_exists?
    fail Thor::Error, ERROR_VERSION if version.nil?
  end

  def berks_install
    shell_exec("chef exec berks install")
  end

  def create_tag
    shell_exec("git tag -a -m \"Version #{version}\" v#{version}") unless tag_exists?
  end

  def push_commits_and_tags
    fail Thor::Error, "Couldn't push commits" unless shell_exec("git push").last == 0
    fail Thor::Error, "Couldn't push tags" unless shell_exec("git push --tags").last == 0
  end

  def berks_upload
    shell_exec("chef exec berks upload --no-ssl-verify")
  end

  private

  def version
    @version ||= begin
      contents = File.read(File.join(Dir.pwd, "metadata.rb"))
      version  = VERSION_MATCH.match(contents)
      return version[1] if version && Gem::Version.correct?(version[1])
      nil
    end
  end

  def metadata_exists?
    File.exist?(File.join(Dir.pwd, "metadata.rb"))
  end

  def git_clean?
    shell_exec("git diff --exit-code").last == 0
  end

  def git_committed?
    shell_exec("git diff-index --quiet --cached HEAD").last == 0
  end

  def tag_exists?
    tags = shell_exec("git tag").first
    tags.include?("v#{version}")
  end
end
