require 'rspec'

describe 'SNMPTransport' do

  before do

    @fake_manager = double(SNMP::Manager)
    allow(SNMP::Manager).to receive(:new).and_return(@fake_manager)

    @fake_varbind = double(SNMP::VarBind, name: '1.2.3.4.5.6.7.8.9', value: 'MyLocation')
    #allow(@fake_varbind).to receive(:value).and_return('')

    @fake_varbind_list = double(SNMP::VarBindList)
    allow(@fake_varbind_list).to receive(:each_varbind).and_yield(@fake_varbind)
    allow(@fake_varbind_list).to receive(:each).and_yield(@fake_varbind)

    
    allow(@fake_manager).to receive(:get).and_return(@fake_varbind_list)

    allow(@fake_manager).to receive(:walk).and_yield(@fake_varbind_list)
    




  end

  it 'should get' do
    expect(SNMPTransport.new('host', 'comm').get('1.2.3.4')).to eq('MyLocation')
  end

  it 'should walk' do
    SNMPTransport.new('host', 'comm').walk(%w(1.3.6.1.2.1.4.22.1.2 1.3.6.1.2.1.4.22.1.3))
  end
end