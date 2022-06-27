require "base64"

module Rakuten::Keiba::Deposit
  class PasswordClient
    @salt = ""

    def initialize(@input : String , @salt_path : String)
      if !File.exists?(@salt_path)
        File.write(@salt_path, create_salt)
        p "Created salt file: " + @salt_path
      end
      if File.read(@salt_path).size == 0
        File.write(@salt_path, create_salt)
      end

      p "Use salt file: " + @salt_path
      salt_file = File.new(@salt_path)
      @salt = File.read(salt_file.path)

      salt_file.close
    end

    def encrypt()
      base64_password = Base64.urlsafe_encode(@input, padding = false)
      front_size = Random.rand(base64_password.size - 1)
      front_password = base64_password[0..front_size]
      rear_password = base64_password[(front_size + 1)..]

      splitted_salt[0] + front_password + splitted_salt[1] + rear_password + splitted_salt[2]
    end

    private def create_salt()
      Random::Secure.urlsafe_base64(Random.rand(64..128), padding = false)
    end

    private def splitted_salt()
      splitted = Array(String).new
      split_size = (@salt.size / 3).to_i
      splitted << @salt[0..(split_size - 1)]
      splitted << @salt[split_size..(split_size * 2)]
      splitted << @salt[((split_size * 2) + 1)..]
      return splitted
    end
  end
end
