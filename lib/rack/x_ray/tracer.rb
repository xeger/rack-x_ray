require 'json'
require 'socket'

module Rack::XRay
  # Implementation class that creates Segment objects from request state,
  # manages state in the Rack environment and elsewhere, and sends UDP packets
  # to X-Ray daemon.
  class Tracer
    TRACE_ID_HEADER = 'HTTP_X_AMZN_TRACE_ID'.freeze

    def initialize(name, recorder)
      @name     = name
      @recorder = recorder
    end

    # @param [Hash] env rack request state
    # @param [String] name human-readable name of this service
    # @return [Segment]
    def start(env)
      trace, parent = trace_and_parent_id(env)

      s = Segment.new
      s.id         = random_id(8)
      s.trace_id   = trace
      s.parent_id  = parent
      s.name       = @name
      s.type       = 'subsegment' if parent
      s.start_time = Time.now.to_f

      s.http_request[:method]     = env['REQUEST_METHOD']
      s.http_request[:url]        = env['REQUEST_URI'] || env['PATH_INFO']
      s.http_request[:user_agent] = env['HTTP_USER_AGENT']
      s.http_request[:client_ip]  = client_ip(env)

      s
    end

    # @param [Segment] segment
    def finish(segment, result)
      status = result.first
      segment.end_time = Time.now.to_f

      segment.http_response[:status] = status

      case status
      when (400..499)
        segment.error = true
      when (500..599)
        segment.fault = true
      end

      @recorder.record(segment)
    end

    private

    # Infer trace and parent ID from request header; generate a new ID if
    # header is absent.
    #
    # @return [Array] pair of String: trace_id and parent_id
    def trace_and_parent_id(env)
      id = nil
      parent = nil

      if h = env[TRACE_ID_HEADER]
        bits = h.split(/\s*;\s*/)
        id = bits.detect { |b| b =~ /^Root=/i }
        id = id[5..-1] if id
        parent = bits.detect { |b| b =~ /^Parent=/i }
        parent = parent[7..-1] if parent
      end

      id = format('%d-%x-%s', 1, Time.now.to_i, random_id(12)) if id.nil?

      [id, parent]
    end

    # @return [String] a hex-encoded n-byte random value
    def random_id(n)
      Random::DEFAULT.bytes(n).unpack('H*').first
    end

    def client_ip(env)
      env['HTTP_X_FORWARDED_FOR'] || env['HTTP_X_REAL_IP'] || env['REMOTE_ADDR']
    end
  end
end
