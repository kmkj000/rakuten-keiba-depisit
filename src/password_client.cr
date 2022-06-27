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

      split_size = (@salt.size / 3).to_i
      front_salt = @salt[0..(split_size - 1)]
      middle_salt = @salt[split_size..(split_size * 2)]
      rear_salt = @salt[((split_size * 2) + 1)..]

      front_salt + front_password + middle_salt + rear_password + rear_salt
    end

    private def create_salt
      Random::Secure.urlsafe_base64(Random.rand(6..32), padding = false)
    end
  end
end
