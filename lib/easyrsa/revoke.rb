module EasyRSA
  class Revoke

    class InvalidCertificate < RuntimeError; end
    class UnableToRevoke < RuntimeError; end
    class MissingParameter < RuntimeError; end
    class MissingCARootKey < RuntimeError; end
    class InvalidCARootPrivateKey < RuntimeError; end

  # Lets get revoking 
    def initialize(revoke=nil, &block)
      if revoke.nil?
        fail EasyRSA::Revoke::InvalidCertificate, 
          'Unable to revoke this cert because it is not a certificate'
      end

    # TODO: Make this a bit better in checking serial vs cert
      if revoke.include?('BEGIN CERTIFICATE')
        cert = OpenSSL::X509::Certificate.new(revoke)
        serialToRevoke = cert.serial
      else
        serialToRevoke = revoke
      end
      
    # Create the revoked object
      @revoked = OpenSSL::X509::Revoked.new

    # Add serial and timestamp of revocation
      @revoked.serial = serialToRevoke
      @revoked.time = Time.now

    end

    def revoke!(cakey=nil, next_update=36000)
      if cakey.nil?
        fail EasyRSA::Revoke::MissingCARootKey,
          'Please provide the root CA cert for the CRL'
      end

    # Get cert details if it's in a file
      unless cakey.is_a? OpenSSL::PKey::RSA
        begin
          cakey = OpenSSL::PKey::RSA.new File.read cakey
        rescue OpenSSL::PKey::RSAError => e
          fail EasyRSA::Revoke::InvalidCARootPrivateKey,
            'This is not a valid Private key file.'
        end
      end

    # This is not a private key
      unless cakey.private?
        fail EasyRSA::Revoke::InvalidCARootPrivateKey,
          'This is not a valid Private key file.'
      end

    # Create the CRL
      @crl = OpenSSL::X509::CRL.new

    # Add the revoked cert
      @crl.add_revoked(@revoked)

    # Needed CRL options
      @crl.last_update = @revoked.time
      @crl.next_update = Time.now + next_update
      @crl.version = 1

    # Update the CRL issuer
      @crl.issuer = EasyRSA::gen_issuer

    # Sign the CRL
      crl = @crl.sign(cakey, OpenSSL::Digest::SHA256.new)
      crl
    end

  end
end