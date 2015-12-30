class Flay::Commands::Release < Thor::Group
  include Flay::Helpers
  include Thor::Actions

  def self.register_with(thor, as: "MISSING NAME")
    thor.register(self, as, as, "creates a release for this cookbook")
  end

  desc "creates a new release and uploads it"
end
