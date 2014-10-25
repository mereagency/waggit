
# Handles all direct interaction with Bash
#
module Waggit::Command

  # Runs a command and passes output to standard out, 
  # and returns the result
  #
  def self.run(command, output = true)
    IO.popen "#{command}" do |fd|
      if output
        until fd.eof?
          puts fd.readline
        end
      end
    end
    return $?.success?
  end
    #Open3.capture3( "#{command}") do |stdin, stdout, status|
    #  if output
     #   until stdin.eof?
      #    stdout.puts stdin.readline
       # end
   #   end
    #return status.success?
    #end
    #return `#{command}`
  #end


end


#require 'shellwords'

# Handles all direct interaction with Bash
#
#class Bash

  # Execute a string as a bash command.
  # Returns true for success,
  # false for failure.
  #
  #def self.run(command)
    #escaped_command = Shellwords.escape(command)
    #return `#{command}`
  #end

  # Returns the exit code of the last command run.
  # 0 for success,
  # non-zero for failure and exit status.
  #
  #def self.exit_status()
  #  return $?.exitstatus
  #end
#end
