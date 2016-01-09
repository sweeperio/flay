require "chef"
require "chef/knife"

module Chef::Knife::FlayKnifeHelpers
  def self.included(base)
    base.class_eval do
      option :data_bag_path, short: "-p", long: "--path", default: nil
      option :secret_file, short: "-s", long: "--secret-file", default: nil
      option :write, short: "-w", long: "--write", boolean: true, default: false
    end
  end

  private

  def write_to_file(bag)
    json = JSON.pretty_generate(bag.to_hash)
    File.open(data_bag_path, "w") { |file| file.write(json) }
  end

  def display(bag)
    output(format_for_display(bag))
  end

  def secret
    @secret ||= begin
      path = config.fetch(:secret_file, Chef::Config[:encrypted_data_bag_secret])
      Chef::EncryptedDataBagItem.load_secret(path)
    end
  end

  def data_bag
    @data_bag ||= Chef::DataBagItem.from_hash(JSON.parse(File.read(data_bag_path)))
  end

  def data_bag_path
    @data_bag_path ||= begin
      base_path = config.fetch(:data_bag_path, Chef::Config[:data_bag_path])
      bag, item = name_args
      File.join(base_path, bag, "#{item}.json")
    end
  end
end
