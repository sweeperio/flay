class Flay::CLI < Thor
  package_name "flay"

  Flay::Commands::Generate.register_with(self, as: "generate")
end
