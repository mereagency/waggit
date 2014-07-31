require 'git.rb'
require 'wagon.rb'
require 'files.rb'

class Waggit

  def self.forcepush()
    puts "forcepush"
  end

  def self.sync()
    puts Git.checkout_master
    puts Git.delete_wagon
    puts Git.delete_local
    puts Git.stash

    puts Git.checkout_new_wagon
    puts Wagon.pull
    Files.clean_scss
    #TODO: Be able to detect if any files were deleted remotely and delete them locally
    #TODO: Remove css files that have an scss equivalent
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

    puts Wagon.push
  end

end
