def stub_command(command, result: ["out", "error", 0])
  expect(Open3).to receive(:capture3).with(command).and_return(result)
end
