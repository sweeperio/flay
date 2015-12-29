module Flay::Helpers
  def shell_exec(command)
    output, error, status = Open3.capture3(command)

    say output
    say error, :red unless status == 0
  end
end
