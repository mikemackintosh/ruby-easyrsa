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

  it 'should throw InvalidCertificateRevocationList if an invalid CRL is provided' do
    existing_crl = <<CERT
-----BEGIN asdfsd CRL-----
CERT
    easyrsa = EasyRSA::Certificate.new(@ca_cert, @ca_key, 'mike', 'mike@ruby-easyrsa.gem')
    g = easyrsa.generate

    expect{
      r = EasyRSA::Revoke.new g[:crt]
      crl = r.revoke! @ca_key, existing_crl
    }.to raise_error(EasyRSA::Revoke::InvalidCertificateRevocationList)
  end

  it 'should successfully revoke certificate by cert pem format' do

    easyrsa = EasyRSA::Certificate.new(@ca_cert, @ca_key, 'mike', 'mike@ruby-easyrsa.gem')
    g = easyrsa.generate

    r = EasyRSA::Revoke.new g[:crt]
    crl = r.revoke! @ca_key
    
    expect(crl.to_pem).to include('BEGIN X509 CRL')
  end

  it 'should successfully revoke certificate with existing CRL' do
    existing_crl = <<CERT
-----BEGIN X509 CRL-----
MIIBjTCB9wIBATANBgkqhkiG9w0BAQsFADCBpDELMAkGA1UEBhMCVVMxETAPBgNV
BAcMCE5ldyBZb3JrMRgwFgYDVQQKDA9NaWtlIE1hY2tpbnRvc2gxGTAXBgNVBAsM
EEVhc3lSU0EgR2VtIFRlc3QxGTAXBgNVBAMMEGVhc3lyc2EtZ2VtLXRlc3QxGTAX
BgNVBCkMEEVhc3lSU0EgR2VtIFRlc3QxFzAVBgkqhkiG9w0BCQEWCG1AenlwLmlv
Fw0xNTA0MjkxNDM4NTJaFw0xNTA0MzAwMDM4NTJaMB4wHAILEKsE81b0gfC2kJ0X
DTE1MDQyOTE0Mzg1MlowDQYJKoZIhvcNAQELBQADgYEArJjrQAcaSYTHPZwpb5h4
VQ47w5KkhWgA1moHelF8KnXwnoV9Cxkm3ztuaDQMMiPyiVB3WLBAqVkkq79SncLk
YsBIP73qW2Hn5b8ZCw+RhlBHvigxKakGIywRGy3+u7P1Jc1s6TVzvSeP5OOzAxNP
f8Tj/fu1lbvyRsPt+XHC+wY=
-----END X509 CRL-----
CERT
    easyrsa = EasyRSA::Certificate.new(@ca_cert, @ca_key, 'mike', 'mike@ruby-easyrsa.gem')
    g = easyrsa.generate

    r = EasyRSA::Revoke.new g[:crt]
    crl = r.revoke! @ca_key, existing_crl

    expect(crl.to_pem).to include('BEGIN X509 CRL')
    expect(existing_crl).to_not eql(crl.to_pem)
  end

end