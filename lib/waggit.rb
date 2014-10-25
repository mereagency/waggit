require 'git'
require 'wagon'
require 'files'
require 'exceptions'

module Waggit

  # Verifies that the current working directory is setup to work with both git and wagon
  #
  def self.test_dir(options={})
    test = true
    if !Git.is_git_dir?
      # FIXME: Cannot find a way to capture the output of the above git method, 
      # so there is another error that is output: 'fatal: Not a git repository 
      # (or any of the parent directories): .git'

      #puts "error: not in a git directory."
      test = false
    end 
    if !Wagon.is_wagon_dir?
      puts "error: Not in a wagon directory."
      test = false
    end 
    if test
      puts "Current directory is both a wagon and a git directory"
    end
    return test
  end

  # Waggit can only really work if it is in a directory that has both git and
  # wagon setup. This finds an appropriate working directory with both waggit 
  # and git and return the path as a string or return nil.
  #
  def self.get_waggit_dir()
    dir = Wagon.get_wagon_path
    puts "error: Unable to find a Wagon directory in your current path." unless dir
    if dir
      dir = Git.is_git_dir?(dir) ? dir : nil
      puts "error: Wagon directory is not setup with git: #{dir}" unless dir
    end
    return dir
  end

  def self.clean(options={})
    dir = get_waggit_dir
    if dir
      Dir.chdir(dir) do 
        Files.clean_css
      end
    end
  end

  # Push local changes to wagon, ignoring git.
  #
  def self.forcepush(options)
    if confirm_push
      dir = get_waggit_dir
      if dir
        Dir.chdir(dir) do 
          Files.clean_css
          Wagon.push(options)
        end
      end
    end
  end

  # Commit local changes and keep in sync with git, then push to wagon.
  #
  def self.push(options)
    if confirm_push
      dir = get_waggit_dir
      if dir
        Dir.chdir(dir) do 
          Git.add_all
          Git.commit_prompt
          Files.clean_css
          if Git.has_changes?
            Git.add_all
            Git.commit "cleaned css"
          end
          Git.pull
          Git.push
          Wagon.push(options)
        end
      end
    end
  end

  def self.pull(options)
    dir = get_waggit_dir
    if dir
      Dir.chdir(dir) do 
        begin
          Git.checkout_master
          Git.delete_wagon
          Git.delete_local
          Git.stash

          Git.checkout_new_wagon
          Wagon.pull(options)
          #TODO: Checkout: http://stackoverflow.com/questions/3515597/git-add-only-non-whitespace-changes
          if Git.has_changes?
            Git.add_all
            Git.commit "merge wagon pull"
          end

          Git.checkout_master
          Git.rebase_wagon
          Git.checkout_master
          Git.merge_wagon

          Git.checkout_new_local
          Git.stash_pop
          Git.add_all
          Git.commit_prompt
          Git.rebase_local
          Git.checkout_master
          Git.merge_local
          Git.delete_wagon
          Git.delete_local
      	rescue WaggitException
          puts "Pull aborted, switching back to master branch"
          Git.checkout_master
          raise
        end
      end
    end
  end

  def self.sync(options)
    dir = get_waggit_dir
    if dir
      Dir.chdir(dir) do 
        begin
          Git.checkout_master
          Git.delete_wagon
          Git.delete_local
          Git.stash

          Git.checkout_new_wagon
          Wagon.pull(options)
          #TODO: Checkout: http://stackoverflow.com/questions/3515597/git-add-only-non-whitespace-changes
          if Git.has_changes?
            Git.add_all
            Git.commit "merge wagon pull"
          end

          Git.checkout_master
          Git.rebase_wagon
          Git.checkout_master
          Git.merge_wagon

          Git.checkout_new_local
          Git.stash_pop
          Git.add_all
          Git.commit_prompt
          Git.rebase_local
          Git.checkout_master
          Git.merge_local
          Git.delete_wagon
          Git.delete_local

          Files.clean_css
          if Git.has_changes?
            Git.add_all
            Git.commit "cleaned css"
          end

          Git.pull
          Git.push

          Wagon.push(options)
        rescue Exception
          puts "Sync aborted, switching back to master branch"
          Git.checkout_master
          raise
        end
      end
    end
  end

  # Since pushing local content can overwrite remote content
  # we want the user to confirm the operation
  #
  def self.confirm_push()
    puts "Performing this operation will overwrite content on the server."
    response = nil
    while response.nil?
      puts "Do you want to continue? [y/n]"
      response = $stdin.gets.chomp.downcase
      case response
      when "y", "yes"
        return true
      when "n", "no"
        return false
      else
        puts "Invalid response! Plese try again."
        response = nil
      end
    end
  end

end
