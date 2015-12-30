class Flay::CLI < Thor
  package_name "flay"

  Flay::Commands::Generate.register_with(self, as: "generate")

  desc "version", "display the current version"
  long_desc "Show the current version of flay"
  def version
    say "flay version: #{Flay::VERSION}"
  end
end
