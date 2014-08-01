require 'command.rb'

class Wagon

  # Converts the provided options into the appropriate
  # string to append to the wagon command
  #
  def self.process_options(options)
    resource_opts = []
    for option in options
      case option
      when "-p"
        resource_opts.push("pages")
      when "-a"
        resource_opts.push("theme_assets")
      end
    end
    return " -r resource_opts.join(' ')"

  end

  def self.pull(options)
    Command.run("bundle exec wagon pull production#{self.process_options}")
  end

  def self.push(options)
    Command.run("bundle exec wagon push production#{self.process_options}")
  end

end
