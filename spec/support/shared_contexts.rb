shared_context "command runners", :command do
  around(:each) do |example|
    $stdout = StringIO.new
    $stderr = StringIO.new

    example.run

    $stdout = STDOUT
    $stderr = STDERR
  end

  def stub_known_command(cmd, success: true)
    cli = known_commands.fetch(cmd)
    stub_command(cli, result: [cli, "error", success ? 0 : 1])
  end

  def invoke_command(*args, options: {})
    command = described_class.new
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
