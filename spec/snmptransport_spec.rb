require 'rspec'

describe 'SNMPTransport' do

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


  end
  it 'should walk' do

    expect(@snmp_transport.walk(%w(1.2.3.4 5.6.7.8))).to eq(
                                                             [
                                                                 %w(aa11cc11ee11 10.10.10.1),
                                                                 %w(aa10bb11cc12 10.10.10.2),
                                                                 %w(ff10ee20dd30 10.10.10.3)
                                                             ]
                                                         )
  end

  it 'should get' do
    expect(@snmp_transport.get('1.2.3.4')).to eq('TSaare')
  end
end