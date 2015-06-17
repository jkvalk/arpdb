require 'snmp'

class SNMPTransport

  attr_accessor :manager

  def initialize(host, community = 'public')
    @manager = SNMP::Manager.new(host: host, community: community, mib_modules: [], retries: 1)
  end

  def walk(oids)
    result = Array.new
    manager.walk(oids) do |snmp_row|
      row = Array.new
      snmp_row.each do |vb|
        row << decode_value(vb)
      end
      result << row
    end
    result
  end

  def get(oid)
    manager.get(oid).each_varbind { |vb| return decode_value(vb) }
  end

  def close
    manager.close
  end

  private

  def decode_value(vb)
    # Absolutely ugly hack to decide if value needs to be unpacked.
    # Add OIDs known to return packed/binary data here.
    # Please recommend correct solution for this.
    if vb.name.to_s =~ /1\.3\.6\.1\.2\.1\.4\.22\.1\.2/
      vb.value.unpack('H*').first
    else
      vb.value.to_s
    end
  end
end