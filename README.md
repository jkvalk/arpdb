[![Build Status](https://travis-ci.org/jkvalk/arpdb.svg?branch=master)](https://travis-ci.org/jkvalk/arpdb)

# Arpdb

Arpdb is a Ruby gem for querying SNMP-enabled network devices for their ARP database. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'arpdb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arpdb

## Usage
```ruby
require 'arpdb'

routers = %w(192.168.1.1 10.1.1.1)
snmp_community = 'secret_community'

adb = Arpdb::Arp.new(routers, snmp_community)

puts adb.mac_to_ip 'aa:bb:cc:dd:ee:ff'
puts adb.ip_to_mac '192.168.1.100'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jkvalk/arpdb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

