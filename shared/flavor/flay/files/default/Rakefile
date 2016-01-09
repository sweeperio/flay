require "foodcritic"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new { |rspec| rspec.rspec_opts = File.read("./.rspec").split("\n") }

RuboCop::RakeTask.new { |rubocop| rubocop.options = %w(-D) }

FoodCritic::Rake::LintTask.new do |foodcritic|
  foodcritic.options[:progress]  = true
  foodcritic.options[:fail_tags] = "any"
end

desc "Run Rubocop and Foodcritic style checks"
task style: [:rubocop, :foodcritic]

desc "Run all style checks and unit tests"
task test: [:style, :spec]

task default: :test
