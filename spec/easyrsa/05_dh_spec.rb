require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe EasyRSA::DH, 'Should' do

  it 'should not throw error when calling new' do
    expect {
      EasyRSA::DH.new
    }.to_not raise_error
  end

  it 'throw error when bit length is too weak' do
    expect {
      EasyRSA::DH.new 512
    }.to raise_error(EasyRSA::DH::BitLengthToWeak)
  end

  it 'should export a real dh param' do
    dh = EasyRSA::DH.new
    output = dh.generate
    expect(output).to include('BEGIN DH PARAMETERS')
  end

end