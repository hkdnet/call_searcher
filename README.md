# CallSearcher

A static analyzer which helps you know where a method is called.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'call_searcher'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install call_searcher

## Usage

```ruby
require 'call_searcher'

s = CallSearcher::Searcher.new { |e| e.mid == :method_name }

result = s.search_dir(root_dir: 'path/to/your/repo', path: '{app,lib,spec}', github: 'org/repo')

result.each do |e|
  puts e.github_url
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hkdnet/call_searcher.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
