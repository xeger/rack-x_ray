# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/x_ray/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-x_ray"
  spec.version       = Rack::XRay::VERSION
  spec.authors       = ["Tony Spataro"]
  spec.email         = ["rubygems@rightscale.com"]

  spec.summary       = %q{Rack middleware for request tracing via AWS X-Ray.}
  spec.homepage      = "https://github.com/xeger/rack-x_ray"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
