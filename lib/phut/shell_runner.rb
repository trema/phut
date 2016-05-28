# frozen_string_literal: true
require 'open3'

module Phut
  # Provides sh method.
  module ShellRunner
    def sudo(command)
      sh "sudo #{command}"
    end

    def sh(command)
      @logger.debug(command) if @logger
      stdout, stderr, status = Open3.capture3(command)
      fail %(Command '#{command}' failed: #{stderr}) unless status.success?
      stdout
    end
  end
end
