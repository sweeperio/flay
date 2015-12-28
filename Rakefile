require "bundler/gem_tasks"

require "cucumber/rake/task"
require "rubocop/rake_task"

Cucumber::Rake::Task.new(:features)
RuboCop::RakeTask.new(:rubocop)

task default: [:rubocop, :features]
