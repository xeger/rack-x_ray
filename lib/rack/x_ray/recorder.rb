module Rack::XRay
  class Recorder
    def initialize(daemon_address, daemon_port)
      @socket = UDPSocket.new
      @socket.connect(daemon_address, daemon_port)
    end

    # @param [Segment] segment
    def record(segment, logger)
      packet = %Q({"format":"json","version":1}\n) + segment.to_json
      @socket.send packet, 0
    rescue SystemCallError => e
      logger.puts "#{e.class.name}: #{e.message}"
    end
  end
end
