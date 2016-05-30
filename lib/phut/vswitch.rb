# frozen_string_literal: true
require 'phut/open_vswitch'

module Phut
  # Open vSwitch controller.
  class Vswitch < OpenVswitch
    name_prefix 'vsw_'
  end
end
