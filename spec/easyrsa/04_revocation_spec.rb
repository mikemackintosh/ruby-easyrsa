require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe EasyRSA::Revoke, 'Should' do
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
      EasyRSA::Revoke.new
    }.to raise_error(EasyRSA::Revoke::InvalidCertificate)
  end

  it 'gets serial of cert to revoke' do
    easyrsa = EasyRSA::Certificate.new(@ca_cert, @ca_key, 'mike', 'mike@ruby-easyrsa.gem')
    g = easyrsa.generate
    r = OpenSSL::X509::Certificate.new g[:crt]
    expect("#{r.serial}").to include("#{Time.now.year}")
  end

  it 'throw error if no CA root is provided' do

    easyrsa = EasyRSA::Certificate.new(@ca_cert, @ca_key, 'mike', 'mike@ruby-easyrsa.gem')
    g = easyrsa.generate

    expect{
      r = EasyRSA::Revoke.new g[:crt]
      r.revoke!
    }.to raise_error(EasyRSA::Revoke::MissingCARootKey)
  end

  it 'throw error if and invalid ca key is provided' do

    easyrsa = EasyRSA::Certificate.new(@ca_cert, @ca_key, 'mike', 'mike@ruby-easyrsa.gem')
    g = easyrsa.generate

    expect{
      r = EasyRSA::Revoke.new g[:crt]
      crl = r.revoke! @ca_cert
    }.to raise_error(EasyRSA::Revoke::InvalidCARootPrivateKey)

  end

  it 'throw error if no CA root is provided' do

    easyrsa = EasyRSA::Certificate.new(@ca_cert, @ca_key, 'mike', 'mike@ruby-easyrsa.gem')
    g = easyrsa.generate

    r = EasyRSA::Revoke.new g[:crt]
    crl = r.revoke! @ca_key
    
    expect(crl).to include('BEGIN X509 CRL')
  end

end