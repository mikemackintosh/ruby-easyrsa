module EasyRSA
  class Certificate

    class UnableToReadCACert < RuntimeError ; end
    class UnableToReadCAKey < RuntimeError ; end
    class BitLengthToWeak < RuntimeError ; end
    class MissingParameter < RuntimeError ; end

    def initialize(ca_crt, ca_key, id=nil, email=nil, bits=4096, &block)

      # ID to generate cert for
      if id.eql? nil
        raise EasyRSA::Certificate::MissingParameter,
          "Please provide an 'id', also known as a subject, for the certificates' CN field."
      end
      @id = id

       # ID to generate cert for
      if email.eql? nil
        raise EasyRSA::Certificate::MissingParameter,
          "Please provide an 'email', also known as a subject, for the certificates' emailAddress field."
      end
      @email = email

      # Validate the existence of the ca_cert file
      unless File.exist? ca_crt
        raise EasyRSA::Certificate::UnableToReadCACert,
          "Certificate Authority Certificate does not exist or is not readable: '#{ca_crt}'. " +
          "Please check it's existence and permissions"
      end
      @ca_cert = OpenSSL::X509::Certificate.new File.read ca_crt

      # Validate the existence of the ca_key file
      unless File.exist? ca_key
        raise EasyRSA::Certificate::UnableToReadCAKey,
          "Certificate Authority Key does not exist or is not readable: '#{ca_key}'. " +
          "Please check it's existence and permissions"
      end
      @ca_key = OpenSSL::PKey::RSA.new File.read ca_key
      
      # Generate Private Key and new Certificate
      if bits < 2048
        raise EasyRSA::Certificate::BitLengthToWeak,
          "Please select a bit length greater than 2048. Default is 4096. You chose '#{bits}'"
      end      
      @key = OpenSSL::PKey::RSA.new(bits)

      # Instantiate a new certificate
      @cert = OpenSSL::X509::Certificate.new

      # This cert should never be valid before now
      @cert.not_before = Time.now

      # Set it to version
      @cert.version = 2     

      instance_eval(&block) if block_given?
    end

    def generate(validfor=10)
  
      # Set the expiration date
      @cert.not_after = EasyRSA::years_from_now(validfor)

      # Add the public key
      @cert.public_key = @key.public_key

      # Generate and assign the serial
      @cert.serial = gen_serial
      
      # Generate subject
      gen_subject

      # Generate issuer
      gen_issuer

      # Add extensions
      add_extensions

      # Sign the cert
      sign_cert_with_ca

      { key: @key.to_pem, crt: @cert.to_pem }

    end

    private

      # Cert subject for End-User
      def gen_subject
        @cert.subject = OpenSSL::X509::Name.parse("/C=#{EasyRSA::Config.country}/" \
          "L=#{EasyRSA::Config.city}/O=#{EasyRSA::Config.company}/OU=#{EasyRSA::Config.orgunit}/CN=#{@id}/" \
          "name=#{@id}/emailAddress=#{@email}")
      end
     
      # Cert issuer details
      def gen_issuer
        @cert.issuer = OpenSSL::X509::Name.parse("/C=#{EasyRSA::Config.country}/" \
          "L=#{EasyRSA::Config.city}/O=#{EasyRSA::Config.company}/OU=#{EasyRSA::Config.orgunit}/" \
          "CN=#{EasyRSA::Config.server}/name=#{EasyRSA::Config.orgunit}/" \
          "emailAddress=#{EasyRSA::Config.email}")
      end

      def add_extensions
        ef = OpenSSL::X509::ExtensionFactory.new
        ef.subject_certificate = @cert
        ef.issuer_certificate = @ca_cert

        @cert.extensions = [
          ef.create_extension('basicConstraints', 'CA:FALSE'),
          ef.create_extension('nsCertType', 'client, objsign'),
          ef.create_extension('nsComment', 'Easy-RSA Generated Certificate'),
          ef.create_extension('subjectKeyIdentifier', 'hash'),
          ef.create_extension('extendedKeyUsage', 'clientAuth'),
          ef.create_extension('keyUsage', 'digitalSignature')
        ]

        @cert.add_extension ef.create_extension('authorityKeyIdentifier',
                                                'keyid,issuer:always')
      end

      def gen_serial
        # Must always be unique, so we do date and @id's chars
        "#{Time.now.strftime("%Y%m%d%H%M%S")}#{@id.unpack('c*').join.to_i}".to_i
      end

      def sign_cert_with_ca
        @cert.sign @ca_key, OpenSSL::Digest::SHA256.new
      end

  end
end