require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe EasyRSA::Certificate, 'Should' do
  include_context 'shared environment'

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
    cert = <<CERTIFICATE
-----BEGIN CERTIFICATE-----
MIIC4TCCAkqgAwIBAgIJANYWnRgYyYmsMA0GCSqGSIb3DQEBBQUAMFUxCzAJBgNV
BAYTAlVTMREwDwYDVQQIEwhOZXcgWW9yazEYMBYGA1UEChMPTWlrZSBNYWNraW50
b3NoMRkwFwYDVQQLExBSdWJ5IEVhc3lSU0EgR2VtMB4XDTE1MDQwODAzMjYxOVoX
DTI1MDQwNTAzMjYxOVowVTELMAkGA1UEBhMCVVMxETAPBgNVBAgTCE5ldyBZb3Jr
MRgwFgYDVQQKEw9NaWtlIE1hY2tpbnRvc2gxGTAXBgNVBAsTEFJ1YnkgRWFzeVJT
QSBHZW0wgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBANN0bDqnyWMKNsLgC9Sf
QW/3mZHrAnuptkYaGcj3b3MHqVbtijYyCD9EtbSsFKftFjJeXNJiRQuWTvEfGl2C
c8wZMDfrA19TpXyfeLYOFfnZb1U3TK1a6tDvrHjbhhiPAQDTfS1mr9bgeac40EiJ
kYtptF4vcphyCOUC2QOi/nhZAgMBAAGjgbgwgbUwHQYDVR0OBBYEFAJpK6ilbgsM
NM38fl/HSlCBr9njMIGFBgNVHSMEfjB8gBQCaSuopW4LDDTN/H5fx0pQga/Z46FZ
pFcwVTELMAkGA1UEBhMCVVMxETAPBgNVBAgTCE5ldyBZb3JrMRgwFgYDVQQKEw9N
aWtlIE1hY2tpbnRvc2gxGTAXBgNVBAsTEFJ1YnkgRWFzeVJTQSBHZW2CCQDWFp0Y
GMmJrDAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4GBAHOVU2vP1a+E/DOf
Jy0UUTuK5hPO1IaT1byN5rWaTFRftpHLsFLnZLTeJkXKd7IcYkwvRFYmUHDHlm7O
4WQiErwmstW967IZbCuUoYKYBEtFlGGzoy2tHdhPVCT8egjqQMs99HaMObNa3kgh
UMxNUqagZQTruqWTDUOXycX/7QXA
-----END CERTIFICATE-----
CERTIFICATE

    key = <<KEY
-----BEGIN RSA PRIVATE KEY-----
MIICXAIBAAKBgQDTdGw6p8ljCjbC4AvUn0Fv95mR6wJ7qbZGGhnI929zB6lW7Yo2
Mgg/RLW0rBSn7RYyXlzSYkULlk7xHxpdgnPMGTA36wNfU6V8n3i2DhX52W9VN0yt
WurQ76x424YYjwEA030tZq/W4HmnONBIiZGLabReL3KYcgjlAtkDov54WQIDAQAB
AoGAB6c7E5RnEZKZEMyTIQryj17izAk5echWtIrVTBTIj91DH8ZRLkz5R3DxMqzX
wowuNXx815B+90BlcwyxI5lJH5Ug5ClUDUhATsrLEnGR+Eg5NLG5K4oXgnQUGTN7
t7MKVUTzRWPc8p9V9Z7asIOMXax+cyaEGVixz9JJfYP8pEECQQDuleHAjZtWA/X/
UhOY3RjYdSSsb5MkDtpPo5WovAgH/7Ek6hx90/FKw5YynGTeskqDvlXlLEMKT1Cl
9s05kCq1AkEA4uOWQAWsNuA54SMMJ+cWTF1h30a7wD5VNmx5C2e5dRX/5Oknc512
m0Ky0zpu3bfWLL8+lJvTYHoQQD/p10hJlQJBAOptlUvJGGeVLsK4WA8suDwAJo/U
dgTJH1N/Tg9k6pNJdzrpWiN8/CtVMSD7sNVs5HC8tdOgASOBOaJJde9oq70CQGp/
fUUr5HwVn9VniAsq0zKhGpGdN/+ywni7Tc3msAyfeO/P6O7B2KxkEGBJq0RzSBrU
4eELi5pbcUlXNsIQckkCQCVQSfWFNkgax/tHFSALdOUkZl+Gy84bGmXPgw4TzQTr
49egzjRvMks+Ej0vO1m8+Zff+9s8qPpeiQI78aY4VLI=
-----END RSA PRIVATE KEY-----
KEY

    expect {
      EasyRSA::Certificate.new('ca.crt', 'ca.key', 'blah', 'blah@blah')
    }.to raise_error(EasyRSA::Certificate::UnableToReadCACert)

    expect {
      EasyRSA::Certificate.new(cert, 'ca.key', 'blah', 'blah@blah')
    }.to raise_error(EasyRSA::Certificate::UnableToReadCAKey)

    expect {
      EasyRSA::Certificate.new(cert, key, 'blah', 'blah@blah')
    }.to_not raise_error

    expect {
      EasyRSA::Certificate.new(cert, @ca_key, 'blah', 'blah@blah')
    }.to_not raise_error

  end

  it 'throw error when bit length is too weak' do

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

  it 'gets generates a valid serial' do
    easyrsa = EasyRSA::Certificate.new(@ca_cert, @ca_key, 'mike', 'mike@ruby-easyrsa.gem')
    g = easyrsa.generate
    r = OpenSSL::X509::Certificate.new g[:crt]
    expect("#{r.serial}").to include("#{Time.now.year}")
  end

  before do
    EasyRSA.configure do |issuer|
      issuer.email = @email
      issuer.server = @server
      issuer.country = @country
      issuer.state = @state
      issuer.city = @city
      issuer.company = @company
      issuer.name = @name
    end
  end

  it 'should allow optional state' do
    easyrsa = EasyRSA::Certificate.new(@ca_cert, @ca_key, 'mike', 'mike@ruby-easyrsa.gem')
    g = easyrsa.generate
    r = OpenSSL::X509::Certificate.new g[:crt]
    expect(r.subject.to_s).to include(@state)
  end

  it 'should allow optional name' do
    easyrsa = EasyRSA::Certificate.new(@ca_cert, @ca_key, 'mike', 'mike@ruby-easyrsa.gem')
    g = easyrsa.generate
    r = OpenSSL::X509::Certificate.new g[:crt]
    expect(r.subject.to_s).to include(@name)
  end

end
