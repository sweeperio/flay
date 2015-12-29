class Flay::Commands::Generate < Thor
  include Flay::Helpers

  def self.register_with(thor, as: "MISSING NAME")
    thor.register(self, as, "#{as} TYPE NAME", "generate a cookbook/recipe")
  end

  desc "cookbook NAME", "generate a cookbook"
  long_desc "generates a cookbook with steeze"
  def cookbook(name)
    shell_exec("chef generate cookbook #{name}")
  end

  desc "recipe NAME", "generate a recipe"
  long_desc "generates a recipe with steeze"
  def recipe(name)
    shell_exec("chef generate recipe #{name}")
  end
end
