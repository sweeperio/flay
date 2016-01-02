describe Chef::Knife::DataBagEncrypt, :data_bag_command do
  let(:data_bag_item) { "keys.plaintext" }

  let(:command) do
    described_class.new([data_bag, data_bag_item])
  end
end
