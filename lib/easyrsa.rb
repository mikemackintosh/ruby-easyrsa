require 'openssl'

require 'easyrsa/version'
require 'easyrsa/config'
require 'easyrsa/certificate'
require 'easyrsa/ca'
#require 'easyrsa/cli'
require 'easyrsa/revoke'
require 'easyrsa/dh'

module EasyRSA

# Extend Self
  extend self

# The Configure Block
  def configure
    block_given? ? yield(Config) : Config
    %w(email server country city company orgunit).each do |key|
      if EasyRSA::Config.instance_variable_get("@#{key}").nil?
        raise EasyRSA::Config::RequiredOptionMissing,
          "Configuration parameter missing: '#{key}'. " +
          "Please add it to the EasyRSA.configure block"
      end
    end
  end
  alias_method :config, :configure

# Helper for years from now
  def years_from_now(i = 10)
    Time.now + i * 365 * 24 * 60 * 60
  end

# Helper for issuer details
  def gen_issuer
    name = "/C=#{EasyRSA::Config.country}"
    name += "/ST=#{EasyRSA::Config.state}" unless !EasyRSA::Config.state || EasyRSA::Config.state.empty?
    name += "/L=#{EasyRSA::Config.city}"
    name += "/O=#{EasyRSA::Config.company}"
    name += "/OU=#{EasyRSA::Config.orgunit}"
    name += "/CN=#{EasyRSA::Config.server}"
    name += "/name=#{EasyRSA::Config.name}" unless !EasyRSA::Config.name || EasyRSA::Config.name.empty?
    name += "/emailAddress=#{EasyRSA::Config.email}"

    OpenSSL::X509::Name.parse(name)
  end

# Helper for generating serials
  def gen_serial(id)
    # Must always be unique, so we do date and id's chars
    "#{Time.now.strftime('%Y%m%d%H%M%S')}#{id.unpack('c*').join.to_i}".to_i
  end

end
