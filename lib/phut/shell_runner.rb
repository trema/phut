# frozen_string_literal: true

require 'open3'
require 'phut/setting'

module Phut
  # Provides sh method.
  module ShellRunner
    def sudo(command)
      sh "sudo #{command}"
    end

    def sh(command)
      Phut.logger.debug(command)
      stdout, stderr, status = Open3.capture3(command)
      raise %(Command '#{command}' failed: #{stderr}) unless status.success?
      stdout
    end
  end
end
