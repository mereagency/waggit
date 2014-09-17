require 'git.rb'
require 'wagon.rb'
require 'files.rb'

module Waggit

  # Verifies that the current working directory is setup to work with both git and wagon
  #
  def self.test()
    puts "test... doesn't work yet"
  end

  def self.clean(options)
    Files.clean_css
  end

  # Push local changes to wagon, ignoring git.
  #
  def self.forcepush(options)
    Files.clean_css
    puts Wagon.push(options)
  end

  # Commit local changes and keep in sync with git, then push to wagon.
  #
  def self.push(options)
    puts Git.add_all
    puts Git.commit_prompt
    Files.clean_css
    if Git.has_changes?
      puts Git.add_all
      puts Git.commit "cleaned css"
    end
    puts Git.pull
    puts Git.push
    puts Wagon.push(options)
  end

  def self.sync(options)
    begin
      puts Git.checkout_master
      puts Git.delete_wagon
      puts Git.delete_local
      puts Git.stash

      puts Git.checkout_new_wagon
      puts Wagon.pull(options)
      #TODO: Checkout: http://stackoverflow.com/questions/3515597/git-add-only-non-whitespace-changes
      if Git.has_changes?
        puts Git.add_all
        puts Git.commit "merge wagon pull"
      end

      puts Git.checkout_master
      puts Git.rebase_wagon
      puts Git.checkout_master
      puts Git.merge_wagon

      puts Git.checkout_new_local
      puts Git.stash_pop
      puts Git.add_all
      puts Git.commit_prompt
      puts Git.rebase_local
      puts Git.checkout_master
      puts Git.merge_local
      puts Git.delete_wagon
      puts Git.delete_local

      Files.clean_css
      if Git.has_changes?
        puts Git.add_all
        puts Git.commit "cleaned css"
      end

      puts Git.pull
      puts Git.push

      puts Wagon.push(options)
    rescue Exception
      puts "Sync aborted, switching back to master branch"
      puts Git.checkout_master
      raise
    end
  end

end
