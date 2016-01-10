describe Flay::Cookbook do
  shared_examples "a cookbook with a name" do
    let(:cookbook) { described_class.new(name) }

    it "sets the cookbook_name correctly" do
      expect(cookbook.cookbook_name).to eq("swpr_foo")
    end

    it "sets the directory_name correctly" do
      expect(cookbook.directory_name).to eq("chef-swpr_foo")
    end
  end

  context "with chef-swpr_ prefix supplied" do
    let(:name) { "chef-swpr_foo" }
    it_behaves_like "a cookbook with a name"
  end

  context "with chef- prefix supplied" do
    let(:name) { "chef-foo" }
    it_behaves_like "a cookbook with a name"
  end

  context "with swpr_ prefix supplied" do
    let(:name) { "swpr_foo" }
    it_behaves_like "a cookbook with a name"
  end

  context "without any prefix" do
    let(:name) { "foo" }
    it_behaves_like "a cookbook with a name"
  end
end
