module EasyRSA
  class DH

    class BitLengthToWeak < RuntimeError; end
    class MissingParameter < RuntimeError; end

    def initialize(bits=1024, &block)
    # Generate DH
      if bits < 1024
        raise EasyRSA::DH::BitLengthToWeak,
          "Please select a bit length greater than 2048. Default is 4096. You chose '#{bits}'"
      end      
      @dh = OpenSSL::PKey::DH.new(bits)

      instance_eval(&block) if block_given?
    end

    def generate
      dh = @dh.generate_key!
      dh.to_pem
    end

  end
end