module Rakuten::Keiba::Deposit
  class PasswordClient
    @salt = ""

    def initialize(@unidentified_password : String , @salt_path : String)
      if !File.exists?(@salt_path)
        File.write(@salt_path, Random::Secure.hex(Random.rand(16)))
        p "Created salt file: " + @salt_path
      end
      if File.read(@salt_path).size == 0
        File.write(@salt_path, Random::Secure.hex(Random.rand(16)))
      end

      p "Use salt file: " + @salt_path
      salt_file = File.new(@salt_path)
      @salt = File.read(salt_file.path)

      salt_file.close
    end

  end
end
