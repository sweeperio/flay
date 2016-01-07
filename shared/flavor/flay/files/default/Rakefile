require "chef"
require "foodcritic"
require "rspec/core/rake_task"
require "rubocop/rake_task"

# Data Bag Helpers
SECRET_FILE        = "./test/integration/encrypted_data_bag_secret".freeze
INPUT_PATH_FORMAT  = "./test/integration/data_bags/%s/%s.plaintext.json".freeze
OUTPUT_PATH_FORMAT = "./test/integration/data_bags/%s/%s.json".freeze

def raw_bag_item(args)
  path = format(INPUT_PATH_FORMAT, *args.values_at(:bag, :item))
  hash = JSON.parse(File.read(path))

  Chef::DataBagItem.from_hash(hash)
end

RSpec::Core::RakeTask.new { |rspec| rspec.rspec_opts = File.read("./.rspec").split("\n") }

RuboCop::RakeTask.new { |rubocop| rubocop.options = %w(-D) }

FoodCritic::Rake::LintTask.new do |foodcritic|
  foodcritic.options[:progress]  = true
  foodcritic.options[:fail_tags] = "any"
end

desc "encrypts a data bag item for integration tests"
task :encrypt_data_bag, [:bag, :item] do |_, args|
  data_bag_item   = raw_bag_item(args)
  data_bag_secret = Chef::EncryptedDataBagItem.load_secret(SECRET_FILE)
  encrypted_item  = Chef::EncryptedDataBagItem.encrypt_data_bag_item(data_bag_item, data_bag_secret)

  pretty_json = JSON.pretty_generate(encrypted_item.to_hash)
  output_path = format(OUTPUT_PATH_FORMAT, *args.values_at(:bag, :item))
  File.open(output_path, "w") { |file| file.write(pretty_json) }

  puts format("encrypted test data bag: %s", output_path)
end

desc "Run Rubocop and Foodcritic style checks"
task style: [:rubocop, :foodcritic]

desc "Run all style checks and unit tests"
task test: [:style, :spec]

task default: :test
