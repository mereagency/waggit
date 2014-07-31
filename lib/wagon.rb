require 'command'

class Wagon

  def self.pull()
    Command.run("bundle exec wagon pull production")
  end

  def self.push()
    Command.run("bundle exec wagon push production")
  end
end
