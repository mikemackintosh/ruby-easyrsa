require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe EasyRSA::Certificate, 'Should' do
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
      EasyRSA::Certificate.new('ca.crt', 'ca.key')
    }.to raise_error(EasyRSA::Certificate::MissingParameter)

  end

  it 'throw error when invalid ca cert is passed' do

    expect {
      EasyRSA::Certificate.new('ca.crt', 'ca.key', 'blah', 'blah@blah')
    }.to raise_error(EasyRSA::Certificate::UnableToReadCACert)

  end

  it 'throw error when invalid ca key is passed' do

    expect {
      EasyRSA::Certificate.new('ca.crt', 'ca.key', 'blah', 'blah@blah')
    }.to raise_error(EasyRSA::Certificate::UnableToReadCACert)

  end

  it 'throw error when invalid ca key is passed' do

    expect {
      EasyRSA::Certificate.new(@ca_cert, @ca_key, 'blah', 'blah@blah', 512)
    }.to raise_error(EasyRSA::Certificate::BitLengthToWeak)

  end

  it 'return keys successfully' do

    easyrsa = EasyRSA::Certificate.new(@ca_cert, @ca_key, 'mike', 'mike@ruby-easyrsa.gem')
    g = easyrsa.generate

    expect(g[:key]).to include('BEGIN RSA PRIVATE KEY')
    expect(g[:crt]).to include('BEGIN CERTIFICATE')    

  end


  it 'return successful in a block as well' do
    g = {}
    EasyRSA::Certificate.new(@ca_cert, @ca_key, 'mike', 'mike@ruby-easyrsa.gem') do |c|
      c.generate.each do |k, v|
        g[k] = v
      end
    end

    expect(g[:key]).to include('BEGIN RSA PRIVATE KEY')
    expect(g[:crt]).to include('BEGIN CERTIFICATE')    

  end

end

@client_id = "sexyhorse"
    @client_email = "sexyhorse@zyp.io"