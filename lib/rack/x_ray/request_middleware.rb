begin
  require 'faraday'
rescue LoadError => e
  # no-op; faraday is an optional dependency
end

if defined?(Faraday::Middleware)
  module Rack::XRay
    class RequestMiddleware < Faraday::Middleware
      register_middleware :x_ray => self

      def call(env)
        if segment = Rack::XRay.segment
          env[:request_headers][Rack::XRay::HTTP_HEADER] =
            "Parent=#{segment.id}; Root=#{segment.trace_id}"
        end

        @app.call env
      end
    end
  end
end
