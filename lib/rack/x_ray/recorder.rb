module Rack::XRay
  class Recorder
    def initialize(daemon_address, daemon_port)
      @socket = UDPSocket.new
      @socket.connect(daemon_address, daemon_port)
    end

    # @param [Segment] segment
    def record(segment)
      packet = %Q({"format":"json","version":1}\n) + segment.to_json
      @socket.send packet, 0
    rescue SystemCallError => e
      # TODO log this
    end
  end
end
