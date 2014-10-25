module Waggit
  class WaggitException < Exception
    attr_reader :msg

    def message
      return @msg
    end

  end
  class GitException < WaggitException
    @msg = "Git Exception."
  end
  class GitMergeException < GitException
    @msg = "Error performing 'git merge'."
  end
  class GitCheckoutException < GitException
    @msg = "Error performing 'git checkout'."
  end
  class GitPullException < GitException
    @msg = "Error performing 'git pull'."
  end
end