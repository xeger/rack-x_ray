module Rack::XRay
  # Middleware for capturing HTTP request-tracing data and sending it to
  # AWS X-Ray daemon via UDP.
  class Middleware
    # @param [#call] app inner Rack app
    # @param [String] name human-readable name of this service
    # @param [String] daemon_address IP address of xray daemon
    # @param [Integer] daemon_port UDP listen port of xray daemon
    def initialize(app, name, daemon_address:'127.0.0.1', daemon_port:2000)
      @app      = app
      recorder  = Recorder.new(daemon_address, daemon_port)
      @tracer   = Tracer.new(name, recorder)
    end

    def call(env)
      trace  = @tracer.start(env)
      result = @app.call(env)
      @tracer.finish(trace, result)
      return *result
    end
  end
end
