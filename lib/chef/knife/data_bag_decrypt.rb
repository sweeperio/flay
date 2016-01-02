require_relative "flay_knife_helpers"

class Chef::Knife::DataBagDecrypt < Chef::Knife
  include Chef::Knife::FlayKnifeHelpers

  banner "knife data bag decrypt DATA_BAG ITEM (options)"
  category "data bag"

  def run
    plain_text_bag = Chef::EncryptedDataBagItem.new(data_bag, secret)
    write_to_file(plain_text_bag) if config.fetch(:write, false)
    display(plain_text_bag)
  end
end
