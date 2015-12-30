def stub_command(command, result: ["out", "error", 0])
  expect(Open3).to receive(:capture3).with(command).and_return(result)
end

def stub_git_tag(version)
  stub_command("git tag -a -m \"Version #{version}\" v#{version}", result: ["success", "", 0])
end

def stub_git_tags(*versions)
  result = versions.join("\n")
  stub_command("git tag", result: [result, "", 0])
end

def stub_metadata(found: true, version: "0.1.0") # rubocop:disable Metrics/AbcSize
  contents = <<-EOF
  name "mycookbook"
  maintainer "Some user"
  EOF

  contents << "\nversion '#{version}'" unless version.nil? || version.empty?
  allow(File).to receive(:exist?).with(metadata_path).and_return(found)
  allow(File).to receive(:read).with(metadata_path).and_return(contents)
end

RSpec::Matchers.define :exit_with_code do |expected_code|
  description { "exit with #{expected_code}" }

  def supports_block_expectations?
    true
  end

  match do |block|
    code = nil

    begin
      block.call
    rescue SystemExit => error
      code = error.status
    end
    code && code == expected_code
  end
end
