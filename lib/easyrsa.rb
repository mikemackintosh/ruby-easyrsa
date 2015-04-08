require 'openssl'
require 'fattr'

require 'easyrsa/version'
require 'easyrsa/config'
require 'easyrsa/certificate'

module EasyRSA

  extend self

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

end