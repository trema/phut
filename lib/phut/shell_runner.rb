module Phut
  # Provides sh method.
  module ShellRunner
    def sh(command)
      system(command) || fail("#{command} failed.")
      @logger.debug(command) if @logger
    end
  end
end
