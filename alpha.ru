require 'pry'

lib = File.expand_path('../lib', __FILE__)
$: << lib unless $:.include?(lib)

require 'rack/x_ray'

host, port = ENV['XRAY_DAEMON'].split(':')
port = Integer(port)
use Rack::XRay, 'alpha', daemon_address: host, daemon_port: port

app = Proc.new do |env|
  sleep(3*rand)
  [200, {'Content-Type' => 'text/plain'}, ["hello world"]]
end

run app
