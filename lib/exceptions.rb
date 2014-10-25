module Waggit
  class WaggitException < Exception
    def initialize(message = "Error performing a waggit operation")
      super(message)
    end
  end

  class GitException < WaggitException
    def initialize(message = "Error performing a git operation")
      super(message)
    end
  end

  class GitMergeException < GitException
    def initialize(message = "Error performing'git merge'")
      super(message)
    end
  end

  class GitCheckoutException < GitException
    def initialize(message = "Error performing 'git checkout'") 
      super(message)
    end
  end

  class GitPullException < GitException
    def initialize(message = "Error performing 'git pull'") 
      super(message)
    end
  end

  class GitAddException < GitException
    def initialize(message = "Error performing 'git add'") 
      super(message)
    end
  end

  class GitCommitException < GitException
    def initialize(message = "Error performing 'git commit'") 
      super(message)
    end
  end

  class GitPushException < GitException
    def initialize(message = "Error performing 'git push'") 
      super(message)
    end
  end

  class GitDeleteBranchException < GitException
    def initialize(message = "Error performing 'git delete'") 
      super(message)
    end
  end

  class GitStashException < GitException
    def initialize(message = "Error performing 'git stash'") 
      super(message)
    end
  end

  class GitRebaseException < GitException
    def initialize(message = "Error performing 'git rebase'") 
      super(message)
    end
  end

end