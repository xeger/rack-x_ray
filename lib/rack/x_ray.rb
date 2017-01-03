require "rack/x_ray/version"
require "rack/x_ray/middleware"
require "rack/x_ray/segment"
require "rack/x_ray/recorder"
require "rack/x_ray/tracer"

module Rack
  module XRay
    # Allocate and initialize a Middleware. This method is provided in order
    # to enable clients to `use Rack::XRay` in Rack application builders
    # without having to worry about the implementation details of this gem.
    #
    # @param [#call] app inner Rack app
    # @param [String] name human-readable name of this service
    # @param [String] daemon_address IP address of xray daemon
    # @param [Integer] daemon_port UDP listen port of xray daemon
    # @return [Middleware]
    def self.new(app, name, daemon_address:'127.0.0.1', daemon_port:2000)
      Middleware.new(app, name,
        daemon_address:daemon_address, daemon_port:daemon_port)
    end
  end
end
