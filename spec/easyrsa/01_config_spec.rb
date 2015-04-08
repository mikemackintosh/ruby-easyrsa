require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe EasyRSA::Config, 'Should' do
  include_context "shared environment"

  it 'throw error when missing required configure parameters' do

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

  it 'configure correctly' do

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

end