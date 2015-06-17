module Arpdb

  # Class to fetch ARP tables from Juniper firewalls, maintain them in
  # memory and perform search operations on the cached data.
  class Arp

    class ArpdbError < StandardError
    end

    attr_accessor :db

    def initialize(hostlist, community = 'public')
      @hostlist = hostlist
      @community = community
      @db = Array.new
    end

    def rescan
      scan
    end

    def scan
      @hostlist.each do |host|
        handle_exceptions do
          st = SNMPTransport.new(host, @community)
          location = st.get('1.3.6.1.2.1.1.6.0')

          st.walk(%w(1.3.6.1.2.1.4.22.1.2 1.3.6.1.2.1.4.22.1.3)).each do |row|
            @db << {mac: row.first, ip: row.last, host: host, location: location}
          end
          st.close
        end

      end
      self
    end

    def mac_to_ip(mac)
      return '' if mac.nil?

      db.each do |line|
        if line[:mac].eql?(mac.downcase.gsub(':', ''))
          return line[:ip]
        end
      end
      String.new
    end

    def ip_to_mac(ip)
      return '' if ip.nil?

      db.each do |line|
        if line[:ip].eql?(ip)
          return line[:mac]
        end
      end
      String.new
    end

    def locate_mac(mac)
      return '' if mac.nil?

      db.each do |line|
        if line[:mac].eql?(mac.downcase.gsub(':', ''))
          return line[:location]
        end
      end
      String.new
    end

    def locate_ip(ip)
      return '' if ip.nil?

      db.each do |line|
        if line[:ip].eql?(ip)
          return line[:location]
        end
      end
      String.new
    end

    private

    def handle_exceptions
      begin
        yield
      rescue => e
        raise ArpdbError, "Exception in Arpdb::Arp: #{e}"
      end
    end

  end
end