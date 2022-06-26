require "base64"

module Rakuten::Keiba::Deposit
  class PasswordClient
    @salt = ""

    def initialize(@unidentified_password : String , @salt_path : String)
      if !File.exists?(@salt_path)
        File.write(@salt_path, Random::Secure.urlsafe_base64(Random.rand(16)))
        p "Created salt file: " + @salt_path
      end
      if File.read(@salt_path).size == 0
        File.write(@salt_path, Random::Secure.urlsafe_base64(Random.rand(16)))
      end

      p "Use salt file: " + @salt_path
      salt_file = File.new(@salt_path)
      @salt = File.read(salt_file.path)

      salt_file.close
    end

    def encrypt()
      base64_password = Base64.urlsafe_encode(@unidentified_password,padding = false)

      front_size = Random.rand(base64_password.size - 1)
      front_password = base64_password[0..front_size]
      rear_password = base64_password[(front_size + 1)..]

      front_password + @salt + rear_password
    end
  end
end
