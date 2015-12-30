shared_context "command runners", :command do
  before(:each) do
    $stdout = StringIO.new
    $stderr = StringIO.new
  end

  after(:each) do
    $stdout = STDOUT
    $stderr = STDERR
  end

  def invoke_command(*args)
    described_class.new.invoke(command_name, args)
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
