require 'paint'

module EasyRSA
  module CLI

    def self.success(message)
      puts " #{Paint['[✓]', :bright, :green]} #{Paint[message, :bright, :white]}"
      exit!
    end
     
    def self.info(message)
      puts " #{Paint['[i]', :bright, :blue]} #{Paint[message, :bright, :white]}"
      exit!
    end

    def self.warning(message)
      puts " #{Paint['[!]', :bright, :orange]} #{Paint[message, :bright, :white]}"
      exit!
    end
    
    def self.fatal(message)
      puts " #{Paint['[x]', :bright, :red]} #{Paint[message, :bright, :white]}"
      exit!
    end

  end
end
