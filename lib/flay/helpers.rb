module Flay::Helpers
  def shell_exec(command, show_output: true)
    output, error, status = Open3.capture3(command)

    if show_output
      say output
      say error, :red unless status == 0
    end

    [output, error, status]
  end

  def shell_exec_quiet(command, error_message: nil)
    status = shell_exec(command, show_output: false).last
    say error_message, :red if error_message && status != 0
    status == 0
  end
end
