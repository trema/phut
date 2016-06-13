# frozen_string_literal: true
require 'active_support/core_ext/array/access'
require 'phut/link'

module Phut
  describe Link do
    def delete_all_link
      `ifconfig -a`.split("\n").each do |each|
        next unless /^(#{Veth::PREFIX}\S+)/ =~ each
        system "sudo ip link delete #{Regexp.last_match(1)} 2>/dev/null"
      end
    end

    before(:each) { delete_all_link }
    after(:each) { delete_all_link }

    describe '.all' do
      When(:all) { Link.all }

      context 'when there is no link' do
        Then { all == [] }
      end

      context 'when there is a link' do
        Given { Link.create('foo', 'bar') }
        Then { all.size == 1 }
        Then { all.first.names == %w(bar foo) }
      end
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

    describe '.find' do
      When(:result) { Link.find(%w(foo bar)) }

      context 'when there is no link' do
        Then { result.nil? }
      end

      context 'when there is a link' do
        Given { Link.create('foo', 'bar') }
        Then { !result.nil? }
        Then { result.names == %w(bar foo) }
      end
    end

    describe '.select' do
      When(:result) { Link.select { |each| each.names == %w(bar foo) } }

      context 'when there is no link' do
        Then { result.empty? }
      end

      context 'when there is a link' do
        Given { Link.create('foo', 'bar') }
        Then { result.size == 1 }
      end
    end

    describe '.each' do
      Given(:links) { [] }
      When { Link.all.each { |each| links << each } }

      context 'when there is no link' do
        Then { links.empty? }
      end

      context 'when there is a link' do
        Given { Link.create('foo', 'bar') }
        Then { links.size == 1 }
        Then { links.first.names == %w(bar foo) }
      end
    end

    describe '.destroy_all' do
      When { Link.destroy_all }
      When(:all) { Link.all }
      Then { all == [] }
    end
  end
end
