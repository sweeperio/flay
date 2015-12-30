module Flay::Helpers
  def shell_exec(command, show_output: true)
    output, error, status = Open3.capture3(command)

    if show_output
      say output
      say error, :red unless status == 0
    end

    [output, error, status]
  end
end
