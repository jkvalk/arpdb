require 'rspec'

describe 'SNMPTransport' do

  before do

    @fake_manager = double(SNMP::Manager)
    allow(SNMP::Manager).to receive(:new).and_return(@fake_manager)

    @fake_varbind = double(SNMP::VarBind, name: '1.2.3.4', value: 'MyLocation')
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

  it 'should unpack binary value' do

    @fake_manager2 = double(SNMP::Manager)
    allow(SNMP::Manager).to receive(:new).and_return(@fake_manager2)

    @fake_varbind2 = double(SNMP::VarBind, name: '1.3.6.1.2.1.4.22.1.2', value: 'MyLocation')
    @fake_varbind_list2 = double(SNMP::VarBindList)
    allow(@fake_varbind_list2).to receive(:each_varbind).and_yield(@fake_varbind2)
    allow(@fake_varbind_list2).to receive(:each).and_yield(@fake_varbind2)


    allow(@fake_manager2).to receive(:get).and_return(@fake_varbind_list2)
    allow(@fake_manager2).to receive(:walk).and_yield(@fake_varbind_list2)

    expect(SNMPTransport.new('host', 'comm').get('1.2.3.4')).to eq('4d794c6f636174696f6e')

  end


end