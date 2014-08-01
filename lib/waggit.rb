require 'git.rb'
require 'wagon.rb'
require 'files.rb'

class Waggit

  # Verifies that the current working directory is setup to work with both git and wagon
  #
  def self.test()
    puts "test... doesn't work yet"
  end

  def self.forcepush(options)
    puts Git.add_all
    puts "Enter a git commit comment:"
    comment = $stdin.gets.chomp
    puts Git.commit(comment)
    puts Git.pull
    puts Git.push
    puts Wagon.push(options)
  end


  # Optional parameters allow you to only sync certain resources.
  # You can use multiple at a time.
  # Current options:
  # pages: true  syncs pages only
  # theme_assets: true syncs theme_assets only
  # no_options: true sync everything
  def self.sync(options)
    puts Git.checkout_master
    puts Git.delete_wagon
    puts Git.delete_local
    puts Git.stash

    puts Git.checkout_new_wagon
    puts Wagon.pull(options)
    Files.clean_scss
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
    Files.clean_scss
    puts Git.add_all
    puts "Enter a git commit comment:"
    comment = $stdin.gets.chomp
    puts Git.commit(comment)
    puts Git.rebase_local
    puts Git.checkout_master
    puts Git.merge_local
    puts Git.delete_wagon
    puts Git.delete_local

    puts Git.pull
    puts Git.push

    puts Wagon.push(options)
  end

end
