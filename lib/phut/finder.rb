# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module Phut
  # Defines find_by method
  module Finder
    def find_by(queries)
      queries.inject(all) do |memo, (attr, value)|
        memo.find_all { |each| each.__send__(attr) == value }
      end.first
    end

    def find_by!(queries)
      name = to_s.demodulize
      find_by(queries) || raise("#{name} #{queries.inspect} not found")
    end
  end
end
