[![Build Status](https://travis-ci.org/jkvalk/arpdb.svg?branch=master)](https://travis-ci.org/jkvalk/arpdb)
[![Gem Version](https://badge.fury.io/rb/arpdb.svg)](http://badge.fury.io/rb/arpdb)
[![Coverage Status](https://coveralls.io/repos/jkvalk/arpdb/badge.svg?branch=master)](https://coveralls.io/r/jkvalk/arpdb?branch=master)

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
include Arpdb

hosts = %w(10.40.5.1 10.43.5.1)
community = 'public'

adb = Arp.new(hosts.collect { |host| SNMPTransport.new(host, community) }).scan

puts adb.mac_to_ip "7a70dec81b02"
puts adb.ip_to_mac "172.27.50.2"

puts adb.locate_mac "7a70dec81b02"
puts adb.locate_ip "172.27.50.2"

adb.rescan

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jkvalk/arpdb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

