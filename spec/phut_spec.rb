require 'phut/setting'

describe Phut do
  Given { allow(FileTest).to receive(:directory?).and_return(true) }

  describe '.pid_dir' do
    Given(:result) { Phut.pid_dir }
    Then { result == Dir.tmpdir }

    context "pid_dir = '/tmp/pid'" do
      Given { Phut.pid_dir = '/tmp/pid' }
      Then { result == '/tmp/pid' }
    end

    context "pid_dir = '.'" do
      Given { Phut.pid_dir = '.' }
      Then { result == File.expand_path('.') }
    end
  end

  describe '.log_dir' do
    Given(:result) { Phut.log_dir }
    Then { result == Dir.tmpdir }

    context "log_dir = '/tmp/log'" do
      Given { Phut.log_dir = '/tmp/log' }
      Then { result == '/tmp/log' }
    end

    context "log_dir = '.'" do
      Given { Phut.log_dir = '.' }
      Then { result == File.expand_path('.') }
    end
  end

  describe '.socket_dir' do
    Given(:result) { Phut.socket_dir }
    Then { result == Dir.tmpdir }

    context "socket_dir = '/tmp/socket'" do
      Given { Phut.socket_dir = '/tmp/socket' }
      Then { result == '/tmp/socket' }
    end
  end
end
