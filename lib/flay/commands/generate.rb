class Flay::Commands::Generate < Thor
  include Flay::Helpers

  ARGS = "-C sweeper.io -m developers@sweeper.io -I mit".freeze

  def self.register_with(thor, as: "MISSING NAME")
    thor.register(self, as, "#{as} TYPE NAME", "generate a cookbook/recipe using flay defaults")
  end

  desc "cookbook NAME", "generate a cookbook"
  long_desc "generates a cookbook with steeze"
  def cookbook(name)
    shell_exec("chef generate cookbook #{name} #{ARGS}")
  end

  desc "recipe NAME", "generate a recipe"
  long_desc "generates a recipe with steeze"
  def recipe(name)
    shell_exec("chef generate recipe #{name} #{ARGS}")
  end
end
