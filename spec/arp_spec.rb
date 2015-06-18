require 'rspec'


describe 'Arp' do

  before(:each) do
    @snmp_transport = instance_double('SNMPTransport', host: '127.0.0.1')
    allow(@snmp_transport).to receive(:get).and_return('TSaare')
    allow(@snmp_transport).to receive(:walk).and_return(
                      [
                          %w(aa11cc11ee11 10.10.10.1),
                          %w(aa10bb11cc12 10.10.10.2),
                          %w(ff10ee20dd30 10.10.10.3)
                      ]
                  )

    @snmp_transports_many = [] << @snmp_transport << @snmp_transport

  end

  it 'should initialize and scan' do

    expect(Arp.new(@snmp_transports_many).scan).to be_an_instance_of(Arp)
  end

  it 'should convert mac to ip' do
    expect(Arp.new(@snmp_transports_many).scan.mac_to_ip('aa11cc11ee11')).to eq('10.10.10.1')
  end

  it 'should convert ip to mac' do
    expect(Arp.new(@snmp_transports_many).scan.ip_to_mac('10.10.10.1')).to eq('aa11cc11ee11')
  end

  it 'should locate ip' do
    expect(Arp.new(@snmp_transports_many).scan.locate_ip('10.10.10.1')).to eq('TSaare')
  end

  it 'should locate mac' do
    expect(Arp.new(@snmp_transports_many).scan.locate_mac('aa11cc11ee11')).to eq('TSaare')
  end

  it 'should rescan' do
    expect(Arp.new(@snmp_transports_many).scan.rescan).to be_an_instance_of(Arp)
  end

  it 'should have a db' do
    expect(Arp.new(@snmp_transports_many).db).to be_empty
    expect(Arp.new(@snmp_transports_many).scan.db).to be_an_instance_of(Array)
    expect(Arp.new(@snmp_transports_many).scan.db).to_not be_empty
  end

  it  'should have snmp_transports' do
    adb = Arp.new(@snmp_transports_many)

    expect(adb.snmp_transports).to be_an_instance_of(Array)

    Arp.new(@snmp_transports_many).snmp_transports.each do |st|
      expect(st).to be_an_instance_of(RSpec::Mocks::InstanceVerifyingDouble)
    end
  end

end