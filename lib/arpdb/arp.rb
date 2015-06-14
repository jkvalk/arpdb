require 'snmp'
require 'ap'

# Class to fetch ARP tables from Juniper firewalls, maintain them in
# memory and perform search operations on the cached data.
module Arpdb

  class Arp

    attr_accessor :db

    # * +hostlist+ - Array of hostnames (strings) who's ARP tables to fetch
    def initialize(hostlist, community = 'public')
      @hostlist = hostlist
      @community = community
      refresh
    end

    def refresh
      @db = []
      @hostlist.each do |host|
        SNMP::Manager.open(host: host, community: @community) do |manager|
          manager.walk(%w(1.3.6.1.2.1.4.22.1.2 1.3.6.1.2.1.4.22.1.3)) do |row|
            mac = row[0].value.unpack('H*')[0]
            ip = row[1].value.to_s
            @db << {mac: mac, ip: ip, host: host}
          end
        end
      end
      self
    end

    # * +mac+ - MAC address. String.
    #    mac_to_ip("a7fea790ffa9")
    def mac_to_ip(mac)
      db.each do |line|
        if line[:mac].eql?(mac.downcase.gsub(':',''))
          return line[:ip]
        end
      end
      ''
    end

    # * +ip+ - IP address. String, decimal notation.
    #    ip_to_mac("10.0.0.1")
    def ip_to_mac(ip)
      db.each do |line|
        if line[:ip].eql?(ip)
          return line[:mac]
        end
      end
      ''
    end

    # Returns the host that has given MAC in it's ARP table
    # * +mac+ - MAC address. String, hex, lowercase, no byte separators.
    #    locate_mac("a7fea790ffa9")
    def locate_mac(mac)
      db.each do |line|
        if line[:mac].eql?(mac)
          return line[:host]
        end
      end
      ''
    end

    # Returns the host that has given IP in it's ARP table
    # * +ip+ - IP address. String, decimal.
    #    locate_mac("10.0.0.1")
    def locate_ip(ip)
      db.each do |line|
        if line[:ip].eql?(ip)
          return line[:host]
        end
      end
      ''
    end

  end
end