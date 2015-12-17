require 'phut/syntax/directive'

module Phut
  class Syntax
    # The 'vswitch(name) { ...attributes... }' directive.
    class VswitchDirective < Directive
      attribute :port

      def initialize(alias_name, &block)
        @attributes = { name: alias_name, port: 6653 }
        instance_eval(&block)
      end

      def dpid(value)
        dpid = if value.is_a?(String) && /^0x/=~ value
                 value.hex
               else
                 value.to_i
               end
        @attributes[:dpid] = dpid
        @attributes[:name] ||= format('%#x', @attributes[:dpid])
      end
      alias_method :datapath_id, :dpid
    end
  end
end
