module Phut
  class Syntax
    # The 'link name_a, name_b' directive.
    class LinkDirective
      # Creates a valid network device name.
      class NetworkDeviceName
        def self.create_from(name)
          name.gsub('.', '_')
        end
      end

      attr_reader :name_a
      attr_reader :name_b
      attr_reader :device_a
      attr_reader :device_b

      def initialize(name_a, name_b)
        @name_a = name_a
        @name_b = name_b
        @device_a = NetworkDeviceName.create_from(@name_a)
        @device_b = NetworkDeviceName.create_from(@name_b)
      end
    end
  end
end
