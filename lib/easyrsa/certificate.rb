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

    # Get cert details if it's in a file
      unless ca_crt.is_a? OpenSSL::X509::Certificate
        if ca_crt.include?('BEGIN CERTIFICATE')
          ca_crt = OpenSSL::X509::Certificate.new ca_crt
        else
          begin
            ca_crt = OpenSSL::X509::Certificate.new File.read ca_crt
          rescue
            fail EasyRSA::Certificate::UnableToReadCACert,
              'Invalid CA Certificate.'
          end
        end        
      end
      @ca_cert = ca_crt      

    # Get cert details if it's in a file
      unless ca_key.is_a? OpenSSL::PKey::RSA
        if ca_key.include?('BEGIN RSA PRIVATE KEY')
          ca_key = OpenSSL::PKey::RSA.new ca_key
        else
          begin
            ca_key = OpenSSL::PKey::RSA.new File.read ca_key
          rescue
            fail EasyRSA::Certificate::UnableToReadCAKey,
              'This is not a valid CA Private key file.'
          end
        end
      end
      @ca_key = ca_key

      
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
      @cert.serial = EasyRSA::gen_serial(@id)
      
      # Generate issuer
      @cert.issuer = EasyRSA::gen_issuer

      # Generate subject
      gen_subject

      # Add extensions
      add_extensions

      # Sign the cert
      sign_cert_with_ca

      { key: @key.to_pem, crt: @cert.to_pem }

    end

    private

      # Cert subject for End-User
      def gen_subject
        subject_name = "/C=#{EasyRSA::Config.country}"
        subject_name += "/ST=#{EasyRSA::Config.state}" unless !EasyRSA::Config.state || EasyRSA::Config.state.empty?
        subject_name += "/L=#{EasyRSA::Config.city}"
        subject_name += "/O=#{EasyRSA::Config.company}"
        subject_name += "/OU=#{EasyRSA::Config.orgunit}"
        subject_name += "/CN=#{@id}"
        subject_name += "/name=#{EasyRSA::Config.name}" unless !EasyRSA::Config.name || EasyRSA::Config.name.empty?
        subject_name += "/emailAddress=#{@email}"

        @cert.subject = OpenSSL::X509::Name.parse(subject_name)
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

      def sign_cert_with_ca
        @cert.sign @ca_key, OpenSSL::Digest::SHA256.new
      end

  end
end
