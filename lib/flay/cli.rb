class Flay::CLI < Thor
  include Thor::Actions

  package_name "flay"

  Flay::Commands::Generate.register_with(self, as: "generate")
  Flay::Commands::Release.register_with(self, as: "release")

  method_option(
    :chef_path,
    type: :string,
    desc: "The path that contains your knife.rb file",
    default: "~/.chef-sweeper/"
  )
  desc "link [--chef-path=PATH]", "symlinks .chef to --chef-path"
  long_desc "Creates a symlink in the current directory from .chef to --chef-path"
  def link
    target_path = File.expand_path(options.fetch("chef_path"))
    target_path << "/" unless target_path.end_with?("/")

    create_link File.join(Dir.pwd, ".chef"), target_path
  end

  desc "version", "display the current version"
  long_desc "Show the current version of flay"
  def version
    say "flay version: #{Flay::VERSION}"
  end
end
