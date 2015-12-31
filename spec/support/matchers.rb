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
