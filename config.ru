require 'pry'

lib = File.expand_path('../lib', __FILE__)
$: << lib unless $:.include?(lib)

require 'rack/x_ray'

use Rack::XRay, 'example'

app = Proc.new do |env|
  sleep(rand(3))
  [200, {'Content-Type' => 'text/plain'}, ["hello world"]]
end

run app
