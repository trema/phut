# frozen_string_literal: true
require 'phut/open_vswitch'

# Base module
module Phut
  # Open vSwitch controller.
  class Vswitch < OpenVswitch; end
  Vswitch.bridge_prefix = 'vsw_'
end
