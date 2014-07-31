require 'command'

class Git

  # Add all local changes to be committed.
  #
  def self.add_all()
    Command.run("git add -A .")
  end

  # Git commit with commit message
  #
  def self.commit(message)
    Command.run("git commit -m '#{message}'")
  end

  # Git push
  #
  def self.push()
    Command.run("git push")
  end

  # Git pull
  #
  def self.pull()
    Command.run("git pull")
  end

  def self.checkout(branch)
    Command.run("git checkout #{branch}")
  end

  def self.checkout_master()
    self.checkout("master")
  end

  def self.checkout_new_wagon()
    self.checkout("-b wagon-banch")
  end

  def self.checkout_new_local()
    self.checkout("-b local-branch")
  end

  def self.delete_branch(branch)
    Command.run("git branch -D #{branch}")
  end

  def self.delete_wagon()
    self.delete_branch("wagon-branch")
  end

  def self.delete_local()
    self.delete_branch("local-branch")
  end

  def self.stash()
    Command.run("git stash")
  end

  def self.stash_pop()
    Command.run("git stash pop")
  end

  def self.merge(branch)
    Command.run("git merge #{branch}")
  end

  def self.merge_wagon()
    self.merge("wagon-branch")
  end

  def self.merge_local()
    self.merge("local-branch")
  end

  def self.rebase(from, to)
    Command.run("git rebase #{} #{}")
  end

  def self.rebase_wagon()
    self.rebase("master", "wagon-branch")
  end

  def self.rebase_local()
    self.rebase("master", "local-branch")
  end

  def self.has_changes?()
    return !!Command.run("git ls-files -m")
  end

end
