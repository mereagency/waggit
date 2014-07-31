#require 'shellwords'

# Handles all direct interaction with Bash
#
class Bash

  # Execute a string as a bash command.
  # Returns true for success,
  # false for failure.
  #
  def self.run(command)
    #escaped_command = Shellwords.escape(command)
    return `#{command}`
  end

  # Returns the exit code of the last command run.
  # 0 for success,
  # non-zero for failure and exit status.
  #
  def self.exit_status()
    return $?.exitstatus
  end
end
