module Flay::Helpers
  def git_root
    @git_root ||= begin
      output, _, status = shell_exec("git rev-parse --show-toplevel")
      return nil unless status == 0
      output.chomp
    end
  end

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
