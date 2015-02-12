require 'phut/settings'
require 'tmpdir'

describe Phut::Settings do
  context "Phut.options = { pid_dir: '/tmp/pid' }" do
    Given { Phut.options = { pid_dir: '/tmp/pid' } }

    describe '.new' do
      describe '[]' do
        When(:result) { Phut::Settings.new[name] }

        context 'with :pid_dir' do
          When(:name) { :pid_dir }
          Then { result == '/tmp/pid' }
        end

        context 'with :log_dir' do
          When(:name) { :log_dir }
          Then { result == Dir.tmpdir }
        end

        context 'with :socket_dir' do
          When(:name) { :socket_dir }
          Then { result == Dir.tmpdir }
        end
      end
    end
  end

  context "Phut.options = { pid_dir: '.' }" do
    Given { Phut.options = { pid_dir: '.' } }

    describe '.new' do
      describe '[]' do
        When(:result) { Phut::Settings.new[name] }

        context 'with :pid_dir' do
          When(:name) { :pid_dir }
          Then { result == File.expand_path('.') }
        end

        context 'with :log_dir' do
          When(:name) { :log_dir }
          Then { result == Dir.tmpdir }
        end

        context 'with :socket_dir' do
          When(:name) { :socket_dir }
          Then { result == Dir.tmpdir }
        end
      end
    end
  end

  context "Phut.options = { log_dir: '/tmp/log' }" do
    Given { Phut.options = { log_dir: '/tmp/log' } }

    describe '.new' do
      describe '[]' do
        When(:result) { Phut::Settings.new[name] }

        context 'with :pid_dir' do
          When(:name) { :pid_dir }
          Then { result == Dir.tmpdir }
        end

        context 'with :log_dir' do
          When(:name) { :log_dir }
          Then { result == '/tmp/log' }
        end

        context 'with :socket_dir' do
          When(:name) { :socket_dir }
          Then { result == Dir.tmpdir }
        end
      end
    end
  end

  context "Phut.options = { log_dir: '.' }" do
    Given { Phut.options = { log_dir: '.' } }

    describe '.new' do
      describe '[]' do
        When(:result) { Phut::Settings.new[name] }

        context 'with :pid_dir' do
          When(:name) { :pid_dir }
          Then { result == Dir.tmpdir }
        end

        context 'with :log_dir' do
          When(:name) { :log_dir }
          Then { result == File.expand_path('.') }
        end

        context 'with :socket_dir' do
          When(:name) { :socket_dir }
          Then { result == Dir.tmpdir }
        end
      end
    end
  end

  context "Phut.options = { socket_dir: '/tmp/socket' }" do
    Given { Phut.options = { socket_dir: '/tmp/socket' } }

    describe '.new' do
      describe '[]' do
        When(:result) { Phut::Settings.new[name] }

        context 'with :pid_dir' do
          When(:name) { :pid_dir }
          Then { result == Dir.tmpdir }
        end

        context 'with :log_dir' do
          When(:name) { :log_dir }
          Then { result == Dir.tmpdir }
        end

        context 'with :socket_dir' do
          When(:name) { :socket_dir }
          Then { result == '/tmp/socket' }
        end
      end
    end
  end

  context "Phut.options = { socket_dir: '.' }" do
    Given { Phut.options = { socket_dir: '.' } }

    describe '.new' do
      describe '[]' do
        When(:result) { Phut::Settings.new[name] }

        context 'with :pid_dir' do
          When(:name) { :pid_dir }
          Then { result == Dir.tmpdir }
        end

        context 'with :log_dir' do
          When(:name) { :log_dir }
          Then { result == Dir.tmpdir }
        end

        context 'with :socket_dir' do
          When(:name) { :socket_dir }
          Then { result == File.expand_path('.') }
        end
      end
    end
  end

  describe '.new' do
    describe '[]' do
      When(:result) { Phut::Settings.new[name] }

      context 'with :INVALID_KEY' do
        When(:name) { :INVALID_KEY }
        Then { result == Failure(KeyError) }
      end
    end
  end
end
