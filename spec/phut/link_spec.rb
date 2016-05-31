# frozen_string_literal: true
require 'active_support/core_ext/array/access'
require 'phut/link'

module Phut
  describe Link do
    def delete_all_link
      `ifconfig -a`.split("\n").each do |each|
        next unless /^(L\S+)/=~ each
        system "sudo ip link delete #{Regexp.last_match(1)} 2>/dev/null"
      end
    end

    before(:each) { delete_all_link }
    after(:each) { delete_all_link }

    describe '.all' do
      When(:all) { Link.all }
      Then { all == [] }
    end

    describe '.create' do
      When(:link) { Link.create(:name1, :name2) }
      When(:all) { Link.all }
      Then { all.size == 1 }

      describe '#device' do
        Then { link.device(:name1) == 'L0_name1' }
        Then { link.device(:name2) == 'L0_name2' }
      end

      describe '#destroy' do
        When { link.destroy }
        Then { Link.all == [] }
      end
    end

    describe '.destroy_all' do
      When { Link.destroy_all }
      When(:all) { Link.all }
      Then { all == [] }
    end
  end
end
