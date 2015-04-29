require 'openssl'
require 'fattr'

require 'easyrsa/version'
require 'easyrsa/config'
require 'easyrsa/certificate'
require 'easyrsa/ca'

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

end