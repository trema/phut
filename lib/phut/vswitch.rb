# frozen_string_literal: true
require 'phut/open_vswitch'
require 'phut/link'

module Phut
  # Open vSwitch controller.
  class Vswitch < OpenVswitch
    name_prefix 'vsw_'

    def self.connect_link
      Link.each do |link|
        select { |vswitch| link.connect_to?(vswitch) }.each do |each|
          each.add_port link.device(each.name)
        end
      end
    end
  end
end
