require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe EasyRSA::Config, 'Should' do
  include_context "shared environment"

  it 'should throw error when missing required configure parameters' do

    expect {
      EasyRSA.configure do |issuer|
        issuer.email = @email
        issuer.server = @server
        issuer.city = @city
        issuer.company = @company
        issuer.orgunit = @orgunit
      end
    }.to raise_error(EasyRSA::Config::RequiredOptionMissing)

  end

  it 'should configure correctly in block format' do

    expect {
      EasyRSA.configure do |issuer|
        issuer.email = @email
        issuer.server = @server
        issuer.country = @country
        issuer.city = @city
        issuer.company = @company
        issuer.orgunit = @orgunit
      end
    }.not_to raise_error

  end

  it 'should configure correctly when in hash form' do

    expect {
      config = { email: @email,
        server: @server,
        country: @country,
        city: @city,
        company: @company,
        orgunit: @orgunit }
      EasyRSA::Config.from_hash config
    }.not_to raise_error

  end

end