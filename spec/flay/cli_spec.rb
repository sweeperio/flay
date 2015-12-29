describe Flay::CLI do
  it "sets the package name" do
    name = described_class.instance_variable_get("@package_name")
    expect(name).to eq("flay")
  end
end
