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
      @snmp_transports = Array(snmp_transports)
      @db = Array.new
    end

    def rescan
      scan
    end

    def scan
      sys_location = '1.3.6.1.2.1.1.6.0'
      ip_net_to_media_phys_address = '1.3.6.1.2.1.4.22.1.2'
      ip_net_to_media_net_address = '1.3.6.1.2.1.4.22.1.3'
      @db = Array.new
      handle_exceptions do
        dirty = false
        snmp_transports.each do |st|
          begin
            st.walk([ip_net_to_media_phys_address, ip_net_to_media_net_address]).each do |mac, ip|
              @db << {mac: mac, ip: ip, host: st.host, location: st.get(sys_location)}
            end
          rescue => e
            dirty = true
            msgs ||= []
            msgs << "SNMPTransport error while scanning #{st.host}; moving to next host (if any)"
            next
          end
        end
        raise msgs.join("; ") if dirty
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
      return '' if mac.nil?
      mac.downcase.gsub(':', '')
    end

  end
end
