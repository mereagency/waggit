module Waggit
  # Base exception for all custom waggit excpetions.
  #
  class WaggitException < Exception
    def initialize(message = 'Error performing a waggit operation')
      super(message)
    end
  end
end
