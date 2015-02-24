require 'drb'
require 'logger'
require 'pio'
require 'socket'

module Phut
  # vhost daemon process
  # rubocop:disable ClassLength
  class VhostDaemon
    # vhost packet format
    class VhostUdp < BinData::Record
      extend Pio::Type::EthernetHeader
      extend Pio::Type::IPv4Header
      extend Pio::Type::UdpHeader

      endian :big

      ethernet_header ether_type: 0x0800
      ipv4_header ip_protocol: 17,
                  ip_total_length: -> { ip_header_length * 4 + udp_length }
      udp_header udp_length: -> { 8 + data.length }, udp_checksum: 0
      string :data, length: 22
    end

    def self.unix_domain_socket(name, socket_dir)
      "drbunix:#{socket_dir}/vhost.#{name}.ctl"
    end

    def self.process(name, socket_dir)
      DRbObject.new_with_uri(unix_domain_socket(name, socket_dir))
    end

    def initialize(options)
      @options = options
      @packets_sent = []
      @packets_received = []
    end

    def run
      @logger = Logger.new(log_file)
      @logger.info("#{@options.fetch(:name)} started " \
                   "(interface = #{@options.fetch(:interface)}, " \
                   "IP address = #{@options.fetch(:ip_address)}, " \
                   "MAC address = #{@options[:mac_address]}, " \
                   "arp_entries = #{@options.fetch(:arp_entries)})")
      @raw_socket = create_raw_socket
      run_as_daemon { start_main_loop }
    end

    def stop
      @stop = true
    end

    # rubocop:disable AbcSize
    def send_packets(dest, send_options)
      return unless @options.fetch(:arp_table)[dest.ip_address]
      udp = VhostUdp.new(source_mac: @options[:mac_address],
                         destination_mac: dest.mac_address,
                         ip_source_address: @options.fetch(:ip_address),
                         ip_destination_address: dest.ip_address)
      send_options[:npackets].to_i.times do
        @packets_sent << udp.snapshot
        @raw_socket.write udp.to_binary_s
        @logger.info "Sent to #{dest.name}: #{udp}"
      end
    end
    # rubocop:enable AbcSize

    def stats
      { tx: @packets_sent, rx: @packets_received }
    end

    private

    def log_file
      "#{@options.fetch(:log_dir)}/vhost.#{@options.fetch(:name)}.log"
    end

    def shutdown
      @logger.info 'Shutting down.'
      FileUtils.rm pid_file if FileTest.exists?(pid_file)
      DRb.thread.kill if DRb.thread
    end

    # rubocop:disable MethodLength
    # rubocop:disable AbcSize
    def start_main_loop
      unix_socket =
        self.class.unix_domain_socket(@options.fetch(:name),
                                      @options.fetch(:socket_dir))
      DRb.start_service(unix_socket, self, UNIXFileMode: 0666)
      read_thread = Thread.start do
        loop do
          begin
            raw_data, = @raw_socket.recvfrom(8192)
            udp = VhostUdp.read(raw_data)
            # TODO: Check @options[:promisc]
            @packets_received << udp.snapshot
            @logger.info "Received: #{udp}"
          rescue Errno::ENETDOWN
            stop
          end
        end
      end
      read_thread.abort_on_exception = true
      DRb.thread.join
    end
    # rubocop:enable MethodLength
    # rubocop:enable AbcSize

    def run_as_daemon
      fork do
        Process.setsid
        redirect_stdio_to_devnull
        trap_signals
        update_pid_file
        yield
      end
    end

    def redirect_stdio_to_devnull
      open('/dev/null', 'r+') do |devnull|
        $stdin.reopen devnull
        $stdout.reopen devnull
        $stderr.reopen devnull
      end
    end

    def trap_signals
      Thread.start do
        loop do
          shutdown if @stop
          sleep 1
        end
      end
      Signal.trap(:TERM) { stop }
      Signal.trap(:INT) { stop }
    end

    ETH_P_ALL = 0x0300
    SIOCGIFINDEX = 0x8933

    def create_raw_socket
      sock = Socket.new(Socket::PF_PACKET, Socket::SOCK_RAW, ETH_P_ALL)

      ifreq = [@options.fetch(:interface)].pack 'a32'
      sock.ioctl(SIOCGIFINDEX, ifreq)

      sll = [Socket::AF_PACKET].pack 's'
      sll << ([ETH_P_ALL].pack 's')
      sll << ifreq[16..20]
      sll << ("\x00" * 12)
      sock.bind sll
      sock
    end

    def running?
      FileTest.exists?(pid_file)
    end

    def create_pid_file
      fail "#{@options.fetch(:name)} is already running." if running?
      update_pid_file
    end

    def update_pid_file
      File.open(pid_file, 'w') { |file| file << Process.pid }
    end

    def pid_file
      File.join @options.fetch(:pid_dir), "vhost.#{@options.fetch(:name)}.pid"
    end
  end
  # rubocop:enable ClassLength
end
