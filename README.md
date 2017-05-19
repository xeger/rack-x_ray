# Rack::XRay

This RubyGem provides a Rack middleware that collects HTTP request-tracing data
and sends it to an AWS X-Ray daemon via UDP.

X-Ray is most useful when timing information is transmitted from both the
client and server sides of a segment; although this gem provides no direct
support for client tracing, it populates thread-local storage with segment
information, readable via `Rack::XRay.segment`, which can be used as the
basis for client instrumentation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-x_ray'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-x_ray

## Usage

Install it like any other Rack middleware by adding a line to your `config.ru`:

```ruby
use Rack::XRay, 'my_microservice'
```

If the X-Ray daemon is listening elsewhere than `localhost:2000`, you will
need to provide some options.

```ruby
use Rack::XRay, 'my_microservice', daemon_address: 'xray', daemon_port: 2020
```

To access segment information for use within your own app:

```ruby
seg = Rack::XRay.segment # returns a Rack::XRay::Segment

seg.id # or name, type, trace_id, parent_id, and so forth
```

The local segment can be used to create subsegments and add tracing headers
to requests made by your process.

## Development

**NOTE:** as this is an expermiental project, there are presently no tests.
Integration testing has proven it to work well with the X-Ray private beta.

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xeger/rack-x_ray. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
