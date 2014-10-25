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
end