require 'command'
require 'exceptions'

module Waggit
  module Git

    @@wagon = "wagon-branch"
    @@local = "local-branch"
    # Add all local changes to be committed.
    #
    def self.add_all()
      Command.run("git add -A .")
    end

    # Git commit, will prompt user for commit message
    #
    def self.commit_prompt()
      return unless has_changes?
      puts "Enter a git commit message:"
      message = $stdin.gets.chomp
      self.commit(message)
    end

    # Git commit using provided message
    def self.commit(message)
      raise GitCommitException unless Command.run("git commit -m '#{message}'")
    end

    # Git push
    #
    def self.push()
      raise GitPushException unless Command.run("git push")
    end

    # Git pull
    #
    def self.pull()
      raise GitPullException unless Command.run("git pull")
    end

    def self.checkout(branch)
      raise GitCheckoutException unless Command.run("git checkout #{branch}")
    end

    def self.checkout_master()
      self.checkout("master")
    end

    def self.checkout_new_wagon()
      self.checkout("-b #{@@wagon}")
    end

    def self.checkout_new_local()
      self.checkout("-b #{@@local}")
    end

    def self.branch_exists?(branch)
      Command.run("git show-ref --verify --quiet refs/heads/#{branch}")
    end

    def self.delete_branch(branch)
      raise GitDeleteBranchException unless Command.run("git branch -D #{branch}")
    end

    def self.delete_wagon()
      self.delete_branch(@@wagon) if branch_exists? @@wagon
    end

    def self.delete_local()
      self.delete_branch(@@local) if branch_exists? @@local
    end

    def self.stash()
      raise GitStashException unless Command.run("git stash")
    end

    def self.stash_pop()
      raise GitStashPopException unless Command.run("git stash pop")
    end

    def self.merge(branch)
      raise GitMergeException unless Command.run("git merge #{branch}")
    end

    def self.merge_wagon()
      self.merge(@@wagon)
    end

    def self.merge_local()
      self.merge(@@local)
    end

    def self.rebase(from, to)
      raise GitRebaseException unless Command.run("git rebase #{} #{}")
    end

    def self.rebase_wagon()
      self.rebase("master", @@wagon)
    end

    def self.rebase_local()
      self.rebase("master", @@local)
    end

    def self.has_changes?()
      return !!Command.run("git ls-files -m")
    end

    def self.clean_whitespace_changes()
    # git stash && git stash apply && git diff -w > ws.patch && git checkout . && git apply --ignore-space-change --ignore-whitespace ws.patch && rm ws.patch
      puts "This does nothin yet"
    end

    # Return true if the provided directory is in a git repo, otherwise false. Can optionally provide wa
    #
    def self.is_git_dir?(dir = Dir.pwd)
        return Dir.chdir dir do 
          return Command.run("git rev-parse", false)
        end
    end
    end
end
