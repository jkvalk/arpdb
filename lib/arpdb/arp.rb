module Arpdb

  # Class to fetch ARP tables from Juniper firewalls, maintain them in
  # memory and perform search operations on the cached data.
  class Arp

    class ArpdbError < StandardError
    end

    attr_accessor :db, :snmp_transports

    # Oh gimme my syringe, I want to do some dependency injection!
    # On a more serious note: snmp_transports is expected to be either
    # Arpdb::SNMPTransport or array of those. This way we can easily pass
    # mocked SNMPTransport here for off-the-hook testing.
    def initialize(snmp_transports)
      snmp_transports.is_a?(Array) ? @snmp_transports = snmp_transports : @snmp_transports = [snmp_transports]
      @db = Array.new
    end

    def rescan
      scan
    end

    def scan
      handle_exceptions do
        snmp_transports.each do |st|
          location = st.get('1.3.6.1.2.1.1.6.0')

          st.walk(%w(1.3.6.1.2.1.4.22.1.2 1.3.6.1.2.1.4.22.1.3)).each do |row|
            @db << {mac: row.first, ip: row.last, host: st.host, location: location}
          end
        end
      end

      self
    end

    def mac_to_ip(mac)
      dblookup(:mac, mac_flatten(mac), :ip)
    end

    def ip_to_mac(ip)
      dblookup(:ip, ip, :mac)
    end

    def locate_mac(mac)
      dblookup(:mac, mac_flatten(mac), :location)
    end

    def locate_ip(ip)
      dblookup(:ip, ip, :location)
    end

    private

    def handle_exceptions
      begin
        yield
      rescue => e
        raise ArpdbError, "Exception in Arpdb::Arp: #{e}"
      end
    end

    def dblookup(key, match_value, return_key)
      return '' if match_value.nil?

      line = db.find { |line| line[key].eql?(match_value) }
      line ? line[return_key] : ''
    end

    def mac_flatten(mac)
      mac.downcase.gsub(':', '')
    end

  end
end