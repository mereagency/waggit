require_relative '../exceptions.rb'
module Waggit::Wagon
  # Base exception for all custom wagon exceptions.
  #
  class WagonException < Waggit::WaggitException
    def initialize(message = 'Error performing a wagon operation')
      super(message)
    end
  end

  # Wagon Exception when an unknown environemnt is used
  #
  class WagonUnknownEnvironmentException < WagonException
    def initialize(message = "Unknown wagon environment")
      if environment_name
        super('#{message}, #{Wagon.environment_name}')
      else
        super(message)
      end
    end
  end

  # Wagon Exception when an unknown environemnt is used
  #
  class WagonTokenException < WagonException
    def initialize(message = "Unable to retrive a token for environment" \
                              "'#{Wagon.environment_name}'")
      super(message)
    end
  end

  class WagonEmptyCredentialsException < WagonException
    def initialize(message = "Unable to read credenitals for environment" \
                              "'#{Wagon.environment_name}'")
      super(message)
    end
  end

  class WagonFileException < WagonException
    def initialize(meassage = 'Unable to locate wagon file')
      super(message)
    end
  end
end
