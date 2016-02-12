require 'drb'
require 'logger'
require 'phut/raw_socket'
require 'pio'

module Phut
  # vhost daemon process
  # rubocop:disable ClassLength
  class VhostDaemon
    def self.unix_domain_socket(name, socket_dir)
      "drbunix:#{socket_dir}/vhost.#{name}.ctl"
    end

    def self.process(name, socket_dir)
      DRbObject.new_with_uri(unix_domain_socket(name, socket_dir))
    end

    def initialize(options)
      @options = options
      reset_stats
    end

    def run
      start_logging
      create_pid_file
      start_daemon
    rescue
      shutdown
    end

    def stop
      @stop = true
    end

    def send_packets(dest, npackets)
      return unless lookup_arp_table(dest.ip_address)
      udp = create_udp_packet(dest)
      npackets.times do
        write_to_raw_socket udp
        @logger.info "Sent to #{dest.name}: #{udp}"
      end
    end

    def stats
      { tx: @packets_sent, rx: @packets_received }
    end

    def reset_stats
      @packets_sent = []
      @packets_received = []
    end

    private

    def start_logging
      @logger = Logger.new(File.open(log_file, 'a'))
      @logger.info("#{@options.fetch(:name)} started " \
                   "(interface = #{@options.fetch(:interface)}," \
                   " IP address = #{@options.fetch(:ip_address)}," \
                   " MAC address = #{@options.fetch(:mac_address)}," \
                   " arp_entries = #{@options.fetch(:arp_entries)})")
    end

    def raw_socket
      @raw_socket ||= RawSocket.new(@options.fetch(:interface))
    end

    def lookup_arp_table(ip_address)
      @options.fetch(:arp_table)[ip_address]
    end

    def write_to_raw_socket(packet)
      @packets_sent << packet.snapshot
      raw_socket.write packet.to_binary_s
    rescue Errno::ENXIO
      # link is disconnected
      true
    end

    def create_udp_packet(dest)
      Pio::Udp.new(source_mac: @options.fetch(:mac_address),
                   destination_mac: dest.mac_address,
                   source_ip_address: @options.fetch(:ip_address),
                   destination_ip_address: dest.ip_address)
    end

    def log_file
      "#{@options.fetch(:log_dir)}/vhost.#{@options.fetch(:name)}.log"
    end

    # rubocop:disable MethodLength
    def read_loop
      loop do
        begin
          raw_data, = raw_socket.recvfrom(8192)
          udp = Pio::Udp.read(raw_data)
          unless @options[:promisc]
            next if udp.destination_ip_address != @options.fetch(:ip_address)
          end
          @logger.info "Received: #{udp}"
          @packets_received << udp.snapshot
        rescue Errno::ENETDOWN
          # link is disconnected
          sleep 1
        end
      end
    end
    # rubocop:enable MethodLength

    def start_daemon
      Process.daemon
      trap_sigint
      update_pid_file
      start_threads_and_join
    end

    def start_threads_and_join
      unix_domain_socket =
        self.class.unix_domain_socket(@options.fetch(:name),
                                      @options.fetch(:socket_dir))
      DRb.start_service(unix_domain_socket, self, UNIXFileMode: 0666)
      Thread.start { read_loop }.abort_on_exception = true
      DRb.thread.join
    end

    def shutdown
      @logger.error $ERROR_INFO if $ERROR_INFO
      @logger.info 'Shutting down...'
      FileUtils.rm pid_file if running?
      DRb.stop_service
      fail $ERROR_INFO if $ERROR_INFO
    end

    def trap_sigint
      Thread.start { shutdown_loop }.abort_on_exception = true
      Signal.trap(:INT) { stop }
    end

    def shutdown_loop
      loop do
        break if @stop
        sleep 0.1
      end
      shutdown
    end

    def create_pid_file
      fail "#{@options.fetch(:name)} is already running." if running?
      update_pid_file
    end

    def update_pid_file
      File.open(pid_file, 'w') { |file| file << Process.pid }
    end

    def running?
      FileTest.exists?(pid_file)
    end

    def pid_file
      File.join @options.fetch(:pid_dir), "vhost.#{@options.fetch(:name)}.pid"
    end
  end
  # rubocop:enable ClassLength
end
