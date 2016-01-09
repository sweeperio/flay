shared_context "shell command runner", :shell_commands do
  def stub_shell_command(command, status: 0, include_both: false)
    cmd, success, error = shell_commands.fetch(command)
    results             = [success, "", 0]
    results             = ["", error, status] unless status == 0
    results             = [success, error, status] if include_both

    expect(Open3).to receive(:capture3).with(cmd).and_return(results)
  end
end

shared_context "command runners", :command do
  let(:command) { described_class.new }

  around(:each) do |example|
    $stdout = StringIO.new
    $stderr = StringIO.new

    example.run

    $stdout = STDOUT
    $stderr = STDERR
  end

  def stub_metadata(file) # rubocop:disable Metrics/AbcSize
    contents      = IO.read(File.expand_path("../../fixtures/#{file}.rb", __FILE__))
    metadata_path = File.join(command.git_root, "metadata.rb")

    allow(File).to receive(:exist?).with(metadata_path).and_return(true)
    allow(File).to receive(:read).with(metadata_path).and_return(contents)
  end

  def invoke(*args, options: {})
    command.invoke_all && return if command.is_a?(Thor::Group)

    command.options = options
    command.invoke(command_name, args)
  end

  def stdout
    $stdout.string.chomp
  end

  def stderr
    $stderr.string.chomp
  end

  def output_lines
    stdout.lines.map(&:chomp)
  end
end

shared_context "data bag command", :data_bag_command do
  let(:data_bag)           { "ejson" }
  let(:data_bag_path)      { File.join(Dir.pwd, "spec", "fixtures", "data_bags") }
  let(:data_bag_item_path) { File.join(data_bag_path, data_bag, "#{data_bag_item}.json") }
  let(:data_bag_secret)    { File.join(Dir.pwd, "spec", "fixtures", "encrypted_data_bag_secret") }

  it_behaves_like "a data bag command"
end
