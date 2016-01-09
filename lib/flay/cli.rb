class Flay::CLI < Thor
  include Thor::Actions
  include Flay::Helpers

  package_name "flay"

  Flay::Commands::Generate.register_with(self, as: "generate")
  Flay::Commands::Release.register_with(self, as: "release")

  method_option :chef_path, type: :string, desc: "Your .chef/ folder", default: "~/.chef-sweeper/"
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

  method_option :write, type: :boolean, desc: "Whether or not to write the file", default: true
  method_option :test, type: :boolean, desc: "Whether or not this is a test data bag", default: false, aliases: "-t"
  desc "encrypt DATA_BAG ITEM (options)", "encrypt a data bag item"
  long_desc "Encrypts a data bag item"
  def encrypt(data_bag, item)
    cmd = "chef exec knife data bag encrypt #{data_bag} #{item}"
    cmd << " -w" if options.fetch("write")
    cmd << " #{test_data_bag_args}" if options.fetch("test")

    shell_exec(cmd)
  end

  method_option :write, type: :boolean, desc: "Whether or not to write the file", default: true
  method_option :test, type: :boolean, desc: "Whether or not this is a test data bag", default: false, aliases: "-t"
  desc "decrypt DATA_BAG ITEM (options)", "decrypt a data bag item"
  long_desc "Decrypts a data bag item"
  def decrypt(data_bag, item)
    cmd = "chef exec knife data bag decrypt #{data_bag} #{item}"
    cmd << " -w" if options.fetch("write")
    cmd << " #{test_data_bag_args}" if options.fetch("test")

    shell_exec(cmd)
  end

  private

  def test_data_bag_args
    "-s test/integration/encrypted_data_bag_secret -p test/integration/data_bags"
  end
end
