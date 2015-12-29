describe Flay do
  it "has a valid version" do
    expect(Flay::VERSION).to_not be_nil
    expect(Gem::Version.correct?(Flay::VERSION)).to be_truthy
  end
end
