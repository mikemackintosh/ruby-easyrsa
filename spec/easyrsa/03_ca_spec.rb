require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe EasyRSA::CA, 'Should' do
  include_context "shared environment"

  before do
    EasyRSA.configure do |issuer|
      issuer.email = @email
      issuer.server = @server
      issuer.country = @country
      issuer.city = @city
      issuer.company = @company
      issuer.orgunit = @orgunit
    end
  end

  it 'throw error when arguments are missing' do
    expect {
      EasyRSA::CA.new
    }.to raise_error(EasyRSA::CA::MissingParameter)
  end

  it 'throw error when invalid ca key is passed' do

    expect {
      EasyRSA::CA.new('sadfsdf')
    }.to raise_error(EasyRSA::CA::InvalidCAName)

  end

  it 'throw error when bit length is too weak' do

    expect {
      EasyRSA::CA.new("CN=ca/DC=example", 512)
    }.to raise_error(EasyRSA::CA::BitLengthToWeak)

  end

  it 'return keys successfully' do

    easyrsa = EasyRSA::CA.new("CN=ca/DC=example")
    g = easyrsa.generate

    expect(g[:key]).to include('BEGIN RSA PRIVATE KEY')
    expect(g[:crt]).to include('BEGIN CERTIFICATE')    

  end

  it 'return successful in a block as well' do
    g = {}
    EasyRSA::CA.new("CN=ca/DC=example") do |c|
      c.generate.each do |k, v|
        g[k] = v
      end
    end

    expect(g[:key]).to include('BEGIN RSA PRIVATE KEY')
    expect(g[:crt]).to include('BEGIN CERTIFICATE')    

  end

end