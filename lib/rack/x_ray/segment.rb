module Rack::XRay
  class Segment
    attr_accessor :name
    attr_accessor :type
    attr_accessor :id
    attr_accessor :trace_id
    attr_accessor :parent_id
    attr_accessor :start_time
    attr_accessor :end_time
    attr_accessor :error
    attr_accessor :fault

    # @return [Hash] bag of HTTP request data
    attr_accessor :http_request

    # @return [Hash] bag of HTTP response data
    attr_accessor :http_response

    def initialize
      @http_request = Hash.new
      @http_response = Hash.new
    end

    def to_h
      h = {
        name: @name, id: @id, trace_id: @trace_id, parent_id: @parent_id,
        start_time: @start_time, end_time: @end_time
      }
      h[:parent_id] = @parent_id if @parent_id
      h[:error] = @error || false
      h[:fault] = @fault || false

      h[:http] = {
        request: @http_request,
        response: @http_response,
      }

      h
    end

    def to_json
      JSON.generate(to_h)
    end
  end
end
