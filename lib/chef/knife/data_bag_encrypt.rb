require_relative "flay_knife_helpers"

class Chef::Knife::DataBagEncrypt < Chef::Knife
  include Chef::Knife::FlayKnifeHelpers

  banner "knife data bag encrypt DATA_BAG ITEM (options)"
  category "data bag"

  def run
    cipher_text_bag = Chef::EncryptedDataBagItem.encrypt_data_bag_item(data_bag, secret)
    write_to_file(cipher_text_bag) if config.fetch(:write, false)
    display(cipher_text_bag)
  end
end
